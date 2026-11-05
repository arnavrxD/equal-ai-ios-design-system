#!/usr/bin/env python3
"""Converts SVG path data (M L H V C Z, absolute or relative) into SwiftUI Path code.
Used to turn the Figma logo vectors into EqualLogoShapes.swift."""
import re, sys

def tokens(d):
    for m in re.finditer(r"[MmLlHhVvCcSsQqZz]|-?(?:\d+\.?\d*|\.\d+)(?:e-?\d+)?", d):
        yield m.group(0)

def to_swift(d, ox=0.0, oy=0.0, var="p"):
    out, toks = [], list(tokens(d))
    i, cmd, x, y, sx, sy = 0, None, 0.0, 0.0, 0.0, 0.0
    f = lambda v: f"{v:.4f}".rstrip("0").rstrip(".")
    pt = lambda a, b: f"CGPoint(x: {f(a + ox)}, y: {f(b + oy)})"
    def num():
        nonlocal i
        v = float(toks[i]); i += 1; return v
    while i < len(toks):
        if re.match(r"[A-Za-z]", toks[i]):
            cmd = toks[i]; i += 1
        rel = cmd.islower(); c = cmd.upper()
        if c == "Z":
            out.append(f"{var}.closeSubpath()"); x, y = sx, sy; continue
        if c == "M":
            a, b = num(), num()
            if rel: a, b = a + x, b + y
            x, y, sx, sy = a, b, a, b
            out.append(f"{var}.move(to: {pt(x, y)})"); cmd = "l" if rel else "L"; continue
        if c == "L":
            a, b = num(), num()
            if rel: a, b = a + x, b + y
            x, y = a, b; out.append(f"{var}.addLine(to: {pt(x, y)})"); continue
        if c == "H":
            a = num(); x = a + x if rel else a; out.append(f"{var}.addLine(to: {pt(x, y)})"); continue
        if c == "V":
            b = num(); y = b + y if rel else b; out.append(f"{var}.addLine(to: {pt(x, y)})"); continue
        if c == "C":
            v = [num() for _ in range(6)]
            if rel: v = [v[0] + x, v[1] + y, v[2] + x, v[3] + y, v[4] + x, v[5] + y]
            out.append(f"{var}.addCurve(to: {pt(v[4], v[5])}, control1: {pt(v[0], v[1])}, control2: {pt(v[2], v[3])})")
            x, y = v[4], v[5]; continue
        raise ValueError("unsupported command " + cmd)
    return out

if __name__ == "__main__":
    print("\n".join(to_swift(open(sys.argv[1]).read())))
