""" sexpr parser"""

import re

__all__ = ("atom", "parse", "serialize", "to_mapping")

word_re = r"""(?s)^(?P<word>[a-zA-Z:\-]+)(?P<rest>.*)"""
ws_re   = r"""(?s)^\s+(?P<rest>.*)"""
int_re  = r"""(?s)^(?P<int>[0-9]+)(?P<rest>.*)"""
str_re = r"""(?s)^"(?P<string>.*?)"(?P<rest>.*)"""

def parse(stng):
    res,rest = parse_any(stng)
    if rest.strip() != "":
        raise RuntimeError("Swank expression could not be completely parsed.")
    return res

def parse_any(stng):
    token, rest = next_token(stng)
    if token == "(":
        return parse_list(rest)
    else:
        return token, rest

def parse_list(stng):
    contents = []
    rest0 = stng
    while True:
        nxt, rest = next_token(rest0)
        if nxt is None:
            raise RuntimeError("Closing ) expected but end of string reached.")
        if nxt == ")":
            return contents, rest
        else:
            c, rest = parse_any(rest0)
            rest0 = rest
            contents.append(c)

def next_token(stng):
    """Returns a pair of the next token and the remaining of the string.
        If there is no next token, returns None for the first part."""
    if len(stng) == 0:
        return None, ""
    rest = stng

    # skip whitespaces...
    while True:
        mr = re.match(ws_re, rest)
        if mr is None:
            break
        rest = mr.group("rest")
        if rest == "":
            return None, ""
    # match parentheses
    next_char = rest[0]
    if next_char == "(" or next_char == ")":
        return next_char, rest[1:]
    # match identifiers
    mr = re.match(word_re, rest)
    if mr != None:
        w = mr.group("word")
        if w == "t":
            w = True
        elif w == "nil":
            w = False
        return w, mr.group("rest")
    # match int literals
    mr = re.match(int_re, rest)
    if mr != None:
        return int(mr.group("int")), mr.group("rest")
    # match string literals
    mr = re.match(str_re, rest)
    if mr != None:
        string, rest = mr.group("string"), mr.group("rest")
        if string and string[-1] == "\\":
            string2, rest = next_token('"' + rest)
            string = string + '"' + string2
        return string, rest
    raise ValueError("Cannot tokenize : %s." % rest)

def to_mapping(items):
    items = items[:]
    ret = {}
    while len(items) >= 2:
        key = items.pop(0)[1:]
        value = items.pop(0)
        ret[key] = value
    return ret

class atom(str):
    pass

def serialize(v):
    if isinstance(v, (list, tuple)):
        return "(" + " ".join(serialize(x) for x in v) + ")"
    elif isinstance(v, dict):
        kv = " ".join(":%s %s" % (k, serialize(v)) for k, v in v.items())
        return "(" + kv + ")"
    elif isinstance(v, atom):
        return v
    elif isinstance(v, basestring):
        return '"%s"' % (v.replace('"', '\\"'),)
    elif isinstance(v, bool):
        return "t" if v else "f"
    elif isinstance(v, int):
        return str(v)
    elif v is None:
        return "nil"
    else:
        raise ValueError("can't serialize %r" % v)
