# Pretty printer for shell variables.
#
# NOTE: We can't use any string as a variable name to store variable names
# which are pretty printed because they overwrite global variables with
# themself name in function. So we must use potential parameters directly to
# reference variable names even if it is not understandable.
#
# TODO: Consider empty array and associative array.
zpp () {
  while (( $# )); do
    if [[ ${(P)+${1}} != 1 ]]; then
      local left right

      if [[ -t 2 ]]; then
        local left='\033[33m' right='\033[m'
      fi

      echo "$left$0: not defined '$1'$right" >&2

      shift
      continue
    fi

    local attrs=${(Pt)1}

    case $attrs in
      scalar* | integer* | float* )
        printf '%s %s=%b\n' $attrs $1 ${(PV)1}
        ;;
      array* )
        printf '%s %s=(\n' $attrs $1
        printf '  %b\n' "${(@PV)1}"
        printf ')\n'
        ;;
      association* )
        printf '%s %s=(\n' $attrs $1
        printf '  [%b]=%b\n' "${(@PVkv)1}"
        printf ')\n'
        ;;
    esac

    shift
  done
}
