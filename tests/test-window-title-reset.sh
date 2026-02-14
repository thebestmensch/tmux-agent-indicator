#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/tests/lib/tmux-test-lib.sh"

trap cleanup_test_server EXIT

setup_test_server "window-title-reset"
create_other_window

run_state needs-input
before_style="$(get_window_option "$WIN" "window-status-style")"
before_current_style="$(get_window_option "$WIN" "window-status-current-style")"
assert_non_empty "$before_style" "window-status-style should be set in needs-input"
assert_non_empty "$before_current_style" "window-status-current-style should be set in needs-input"

tmux_cmd run-shell "$ROOT_DIR/scripts/pane-focus-in.sh \"$OTHER_PANE\" \"$OTHER_WIN\""

after_style="$(get_window_option "$WIN" "window-status-style")"
after_current_style="$(get_window_option "$WIN" "window-status-current-style")"
assert_empty "$after_style" "window-status-style should reset after switching windows"
assert_empty "$after_current_style" "window-status-current-style should reset after switching windows"

pass "window title styles reset on window switch"
