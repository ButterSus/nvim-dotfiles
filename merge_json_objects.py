"""
Script I made to make it easier to manage keymap.json unbind "GUI" output

It'll ask you for rules first, if you understand how rules work,
this script will guarantee you 100% safety for merging any JSONs

To make rules persistents it also exports rules.json file
"""

import logging
from collections.abc import Iterable, Iterator
from copy import deepcopy
from itertools import combinations
from pprint import pprint
from types import TracebackType
from typing import Final, Literal, NotRequired, Self, TypedDict, overload

import json5 as json

type JSONValue = (
    dict[str, "JSONValue"] | list["JSONValue"] | str | int | float | bool | None
)

type PolicyPath = tuple[str, ...]
type ContainerType = Literal["dict", "array"]


class DictPolicyRule(TypedDict):
    type: Literal["dict"]
    policy: Literal["DenyAll", "AcceptAll", "AcceptSet"]
    allowed_keys: NotRequired[list[str]]


class ArrayPolicyRule(TypedDict):
    type: Literal["array"]
    policy: Literal["DenyAll", "AcceptAll", "AcceptUnique"]


type PolicyRule = DictPolicyRule | ArrayPolicyRule
type RulesType = dict[str, list[PolicyRule]]
type PendingPolicy = tuple[PolicyPath, ContainerType, list[str] | None]

logger = logging.getLogger(__name__)


class JSONMerger:
    def get_default_rules(self) -> RulesType:
        return {}

    __rules_file: str
    __rules: RulesType | None
    __rules_need_write: bool

    @property
    def rules(self) -> RulesType:
        return deepcopy(self.__get_rules())

    def __get_rules(self) -> RulesType:
        if self.__rules is None:
            raise RuntimeError(
                f"Rules were not initialized. Please use 'with {self.__class__.__name__}(...) as jm: ...'"
            )
        return self.__rules

    def __init__(self, rules_file: str | None = None) -> None:
        if rules_file is None:
            self.__rules_file = "rules.json"
            logger.info(
                "Rules filename not provided, " + "falling back to default: %s",
                self.__rules_file,
            )
        else:
            self.__rules_file = rules_file
        self.__rules = None
        self.__rules_need_write = False

    # ----------
    # Rules file

    def __enter__(self) -> Self:
        self.__rules = self.__load_rules()
        return self

    def __exit__(
        self,
        _exc_type: type[BaseException] | None,
        _exc_value: BaseException | None,
        _traceback: TracebackType | None,
    ) -> None:
        if self.__rules_need_write:
            self.__store_rules()

    def __load_rules(self) -> RulesType:
        try:
            with open(self.__rules_file, "r") as f:
                return json.load(f)  # pyright: ignore[reportUnknownMemberType, reportAny]
        except FileNotFoundError:
            logger.warning(
                "Rules file %s not found, using default rules", self.__rules_file
            )
            return self.get_default_rules()
        except (ValueError, UnicodeDecodeError) as e:
            logger.warning(
                "Rules file %s contains invalid JSON (%s), using default rules",
                self.__rules_file,
                e,
            )
            return self.get_default_rules()

    def __store_rules(self) -> None:
        with open(self.__rules_file, "w") as f:
            json.dump(  # pyright: ignore[reportUnknownMemberType]
                self.__get_rules(), f, indent=2, quote_keys=True, trailing_commas=False
            )

    # ------------
    # Policy logic

    def __encode_path(self, path: PolicyPath) -> str:
        return "/".join(path)

    @overload
    def __get_policy(
        self, path: PolicyPath, container_type: Literal["dict"]
    ) -> DictPolicyRule | None: ...

    @overload
    def __get_policy(
        self, path: PolicyPath, container_type: Literal["array"]
    ) -> ArrayPolicyRule | None: ...

    def __get_policy(
        self, path: PolicyPath, container_type: ContainerType
    ) -> PolicyRule | None:
        rules = self.__get_rules()
        path_key = self.__encode_path(path)
        if path_key not in rules:
            return None

        rules_list = rules[path_key]
        for rule in rules_list:
            if rule["type"] == container_type:
                return deepcopy(rule)
        return None

    def __set_policy(self, path: PolicyPath, _rule: PolicyRule) -> None:
        rules = self.__get_rules()
        path_key = self.__encode_path(path)
        owned_rule = deepcopy(_rule)
        container_type = owned_rule["type"]

        if path_key not in rules:
            rules[path_key] = []

        rules_list = rules[path_key]
        for i, rule_item in enumerate(rules_list):
            if rule_item["type"] == container_type:
                self.__rules_need_write |= rule_item != owned_rule
                rules_list[i] = owned_rule
                break
        else:
            rules_list.append(owned_rule)
            self.__rules_need_write = True

    # -------------------
    # Interactive prompts

    __DICT_POLICY_MENU: Final = (
        ("1", "DenyAll", "Reject all new keys at this scope"),
        ("2", "AcceptAll", "Allow all current/future keys at this scope"),
        ("3", "AcceptSet", "Prompt key-by-key"),
    )

    __ARRAY_POLICY_MENU: Final = (
        ("1", "DenyAll", "Reject array element changes"),
        ("2", "AcceptAll", "Allow array element expansion"),
        ("3", "AcceptUnique", "Allow only unique array elements"),
    )

    def __prompt_dict_policy(
        self, path: PolicyPath
    ) -> Literal["DenyAll", "AcceptAll", "AcceptSet"]:
        path_str = self.__encode_path(path) if path else "ROOT"
        print(f"\n[Dict Policy Needed] Path: '{path_str}'")
        for key, name, desc in self.__DICT_POLICY_MENU:
            print(f"  {key}: {name:<10} ({desc})")

        while True:
            available_opts = [k for k, *_ in self.__DICT_POLICY_MENU]
            choice = input(f"Select policy [{'/'.join(available_opts)}]: ").strip()

            match choice:
                case "1":
                    return "DenyAll"
                case "2":
                    return "AcceptAll"
                case "3":
                    return "AcceptSet"
                case _:
                    print("Incorrect choice input. Try again")
                    continue

    def __prompt_accept_key(self, path: PolicyPath, key: str) -> bool:
        path_str = self.__encode_path(path) if path else "ROOT"
        while True:
            choice = input(f"[{path_str}] Allow key '{key}'? [y/n]: ").strip().lower()
            if choice in ("y", "n"):
                return choice == "y"
            else:
                print("Incorrect choice input. Try again")

    def __resolve_dict_policy(
        self, path: PolicyPath, new_keys: list[str], *, interactive: bool
    ) -> None:
        existing_rule = self.__get_policy(path, "dict")

        if existing_rule is not None:
            assert existing_rule["policy"] == "AcceptSet"
            allowed = set(existing_rule.get("allowed_keys", []))

            if interactive:
                for key in new_keys:
                    if self.__prompt_accept_key(path, key):
                        allowed.add(key)

            self.__set_policy(
                path,
                {
                    "type": "dict",
                    "policy": "AcceptSet",
                    "allowed_keys": sorted(allowed),
                },
            )
            return

        if not interactive:
            self.__set_policy(path, {"type": "dict", "policy": "DenyAll"})
            return

        policy = self.__prompt_dict_policy(path)

        match policy:
            case "DenyAll" | "AcceptAll":
                self.__set_policy(path, {"type": "dict", "policy": policy})
            case "AcceptSet":
                allowed: set[str] = set()
                for key in new_keys:
                    if self.__prompt_accept_key(path, key):
                        allowed.add(key)
                self.__set_policy(
                    path,
                    {
                        "type": "dict",
                        "policy": "AcceptSet",
                        "allowed_keys": sorted(allowed),
                    },
                )

    def __prompt_array_policy(
        self, path: PolicyPath
    ) -> Literal["DenyAll", "AcceptAll", "AcceptUnique"]:
        path_str = self.__encode_path(path) if path else "ROOT"
        print(f"\n[Array Policy Needed] Path: '{path_str}' | Array expansion detected")
        for key, name, desc in self.__ARRAY_POLICY_MENU:
            print(f"  {key}: {name:<10} ({desc})")

        while True:
            available_opts = [k for k, *_ in self.__ARRAY_POLICY_MENU]
            choice = input(f"Select policy [{'/'.join(available_opts)}]: ").strip()

            match choice:
                case "1":
                    return "DenyAll"
                case "2":
                    return "AcceptAll"
                case "3":
                    return "AcceptUnique"
                case _:
                    print("Incorrect choice input. Try again")
                    continue

    def __resolve_pending_policies(
        self, pending: list[PendingPolicy], *, interactive: bool
    ) -> None:
        for path, container_type, keys_or_none in pending:
            if container_type == "dict":
                assert keys_or_none is not None
                self.__resolve_dict_policy(path, keys_or_none, interactive=interactive)
            elif container_type == "array":
                if self.__get_policy(path, "array") is None:
                    policy: Literal["DenyAll", "AcceptAll", "AcceptUnique"]
                    if interactive:
                        policy = self.__prompt_array_policy(path)
                    else:
                        policy = "DenyAll"
                    self.__set_policy(path, {"type": "array", "policy": policy})
            else:
                raise RuntimeError(f"Unexpected container_type: {container_type!r}")

    # --------------------
    # Discovery (pre-pass)

    def __discover_pending_policies(
        self, path: PolicyPath, objs: list[JSONValue]
    ) -> list[PendingPolicy]:
        pending: list[PendingPolicy] = []
        path_str = self.__encode_path(path) if path else "ROOT"

        dicts = [o for o in objs if isinstance(o, dict)]
        lists = [o for o in objs if isinstance(o, list)]

        existing_dict_rule = self.__get_policy(path, "dict")

        if dicts and (
            existing_dict_rule is None or existing_dict_rule["policy"] == "AcceptSet"
        ):
            all_keys: set[str] = {key for d in dicts for key in d}
            common_keys: set[str] = set.intersection(*(set(d.keys()) for d in dicts))  # pyright: ignore[reportUnknownMemberType, reportUnknownVariableType]
            differing_keys: set[str] = all_keys - common_keys
            if existing_dict_rule is None and differing_keys:
                logger.debug(
                    "Path '%-20s': no dict policy yet, %-3d differing key(s) found (%s) -> pending new-path decision",
                    path_str,
                    len(differing_keys),
                    self.__format_items(differing_keys),
                )
                pending.append((path, "dict", sorted(differing_keys)))
            elif (
                existing_dict_rule is not None
                and existing_dict_rule["policy"] == "AcceptSet"
            ):
                allowed_keys = existing_dict_rule["allowed_keys"]  # pyright: ignore[reportTypedDictNotRequiredAccess]
                new_keys = [key for key in differing_keys if key not in allowed_keys]
                if new_keys:
                    logger.debug(
                        "Path '%-20s': AcceptSet policy exists, %-3d new key(s) not in allowed_keys (%s) -> pending per-key decisions",
                        path_str,
                        len(new_keys),
                        self.__format_items(new_keys),
                    )
                    pending.append((path, "dict", sorted(new_keys)))

        if lists and self.__get_policy(path, "array") is None:
            first = lists[0]
            if any(other != first for other in lists[1:]):
                logger.debug(
                    "Path '%-20s': %-3d array(s) found with differing content -> pending array decision",
                    path_str,
                    len(lists),
                )
                pending.append((path, "array", None))

        return pending

    def __walk_all_paths(
        self, path: PolicyPath, objs: list[JSONValue]
    ) -> Iterator[tuple[PolicyPath, list[JSONValue]]]:
        yield path, objs

        dicts = [o for o in objs if isinstance(o, dict)]

        if not dicts:
            return

        all_keys: set[str] = {key for d in dicts for key in d}
        for key in all_keys:
            sub_objs = [d[key] for d in dicts if key in d]
            yield from self.__walk_all_paths(path + (key,), sub_objs)

    def discover_all_pending_policies(
        self, objs: list[JSONValue]
    ) -> list[PendingPolicy]:
        pending: list[PendingPolicy] = []
        for path, objs_at_path in self.__walk_all_paths((), objs):
            pending.extend(self.__discover_pending_policies(path, objs_at_path))
        return pending

    # ---------------
    # General methods

    def __can_merge(self, path: PolicyPath, a: JSONValue, b: JSONValue) -> bool:
        if type(a) is not type(b):
            return False

        if isinstance(a, dict):
            assert isinstance(b, dict)
            differing = a.keys() ^ b.keys()

            rule = self.__get_policy(path, "dict")
            if rule is None or rule["policy"] == "DenyAll":
                if differing:
                    return False
            elif rule["policy"] == "AcceptSet":
                allowed = set(rule.get("allowed_keys", []))
                if not differing <= allowed:
                    return False
            # AcceptAll: no keyset restriction
            for key in a.keys() & b.keys():
                if not self.__can_merge(path + (key,), a[key], b[key]):
                    return False
            return True

        if isinstance(a, list):
            assert isinstance(b, list)
            rule = self.__get_policy(path, "array")
            if rule is None or rule["policy"] == "DenyAll":
                return a == b
            # AcceptAll / AcceptUnique: any array content is compatible for
            # merging (the actual dedup for AcceptUnique happens in
            # __merge_pair, not here)
            return True

        # primitive (str, int, float, bool, None)
        return a == b

    def __merge_pair(self, path: PolicyPath, a: JSONValue, b: JSONValue) -> JSONValue:
        if isinstance(a, dict):
            assert isinstance(b, dict)
            result: dict[str, JSONValue] = {}
            for key in a.keys() | b.keys():
                if key in a and key in b:
                    result[key] = self.__merge_pair(path + (key,), a[key], b[key])
                elif key in a:
                    result[key] = deepcopy(a[key])
                else:
                    result[key] = deepcopy(b[key])
            return result

        if isinstance(a, list):
            assert isinstance(b, list)
            rule = self.__get_policy(path, "array")
            combined = deepcopy(a) + deepcopy(b)
            if rule is not None and rule["policy"] == "AcceptUnique":
                # TODO: only meaningful for primitive elements per the design note
                # in __discover_pending_policies; dedup here treats dict/list
                # elements as always-distinct since they're unhashable
                seen: list[JSONValue] = []
                deduped: list[JSONValue] = []
                for item in combined:
                    if isinstance(item, (dict, list)) or item not in seen:
                        deduped.append(item)
                        seen.append(item)
                return deduped
            return combined

        # primitives, a == b was already guaranteed by __can_merge
        return deepcopy(a)

    def merge(self, objs: list[JSONValue]) -> list[JSONValue]:
        n = len(objs)
        parent = list(range(n))

        def find(x: int) -> int:
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        def union(x: int, y: int) -> None:
            rx, ry = find(x), find(y)
            if rx != ry:
                parent[rx] = ry

        for i, j in combinations(range(n), 2):
            if self.__can_merge((), objs[i], objs[j]):
                union(i, j)

        groups: dict[int, list[int]] = {}
        for idx in range(n):
            groups.setdefault(find(idx), []).append(idx)

        result: list[JSONValue] = []
        for indices in groups.values():
            merged = objs[indices[0]]
            for idx in indices[1:]:
                merged = self.__merge_pair((), merged, objs[idx])
            result.append(deepcopy(merged))

        return result

    def generate_policies(
        self, objs: list[JSONValue], *, interactive: bool = False
    ) -> None:
        for path, objs_at_path in self.__walk_all_paths((), objs):
            self.__resolve_pending_policies(
                self.__discover_pending_policies(path, objs_at_path),
                interactive=interactive,
            )

    # ------------
    # Util methods

    @staticmethod
    def __format_items(items: Iterable[object], max_length: int = 60) -> str:
        sorted_items = sorted(str(item) for item in items)
        if not sorted_items:
            return "(none)"

        shown: list[str] = []
        remaining = len(sorted_items)

        for item in sorted_items:
            candidate = shown + [item]
            joined = ", ".join(candidate)
            suffix = (
                f", ... (+{remaining - len(candidate)})"
                if remaining > len(candidate)
                else ""
            )
            if len(joined) + len(suffix) > max_length and shown:
                break
            shown = candidate

        joined = ", ".join(shown)
        if len(shown) < remaining:
            return f"{joined}, ... (+{remaining - len(shown)})"
        return joined


if __name__ == "__main__":
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s %(levelname)s %(name)s: %(message)s",
    )
    with JSONMerger() as jm, open("keymap.json") as f:
        print("Parsing JSON...")
        raw_data: JSONValue = json.loads(f.read())  # pyright: ignore[reportAny]
        print("Successfully parsed")

        print("\n--- Raw data ---")
        pprint(raw_data)
        print()

        if not isinstance(raw_data, list):
            raise TypeError(
                f"Expected a JSON list at root, got {type(raw_data).__name__}"
            )
        objs: list[JSONValue] = raw_data

        print("Discovering pending policies...")
        pending_policies = list(jm.discover_all_pending_policies(objs))

        print("\n--- Discovered policies ---")
        for pending_policy in pending_policies:
            print(pending_policy)
        print()

        print("Running interactive policies generator...")
        jm.generate_policies(objs, interactive=True)

        print("\n--- Dumping resolved rules ---")
        pprint(jm.rules)
        print()

        print(f"Merging {len(objs)} top-level objects...")
        merged = jm.merge(objs)

        print(f"\n--- Merge result: {len(objs)} objects -> {len(merged)} objects ---")
        pprint(merged)
        print()

        output_file = "keymap.merged.json"
        with open(output_file, "w") as out:
            json.dump(  # pyright: ignore[reportUnknownMemberType]
                merged, out, indent=2, quote_keys=True, trailing_commas=False
            )
        print(f"Wrote merged result to {output_file}")
