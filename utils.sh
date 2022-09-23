is_cross_compile() {
  [[ -n "$1" ]] && grep -q "cross-compile" <<< "$1"
}
