#/bin/bash

########################
# MOCK.SH: A short script to test that MOCKBBINST is generating the
# right output to stdout, stderr, and setting the process exit code
########################

##########################################
# thank you: https://stackoverflow.com/questions/11027679/capture-stdout-and-stderr-into-different-variables
# thank you: https://stackoverflow.com/users/490291/tino
# usage: grabAllValues STDOUTvar STDERRvar command arg1...argn
# get output for stdout, stderr, and process exit code
grabAllValues()
{
eval "$({
__2="$(
  { __1="$("${@:3}")"; } 2>&1;
  ret=$?;
  printf '%q=%q\n' "$1" "$__1" >&2;
  exit $ret
  )"
ret="$?";
printf '%s=%q\n' "$2" "$__2" >&2;
printf '( exit %q )' "$ret" >&2;
} 2>&1 )";
}
##########################################

grabAllValues vStderr vStdout mockbbinst

echo "retval $?"
echo "stdout: $vStderr"
echo "stderr: $vStdout"