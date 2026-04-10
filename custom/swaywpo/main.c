#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "swaymsg.h"

int main(int argc, char *argv[]) {
  if (argc < 3) {
    fprintf(stderr, "Usage: %s <action> <space_name>\n", argv[0]);
    fprintf(stderr, "  Actions: focus, container-to\n");
    return 1;
  }

  const char *action        = argv[1];
  const char *workspace_num = argv[2];
  const char *output_index  = swaymsg_get_focused_output();

  // Build a unique workspace name: "<output>-<workspace_num>"
  // e.g. output DP-2, space 3 -> "DP-2-3"
  char workspace_id[64];
  snprintf(workspace_id, sizeof(workspace_id), "OUTPUT%s-%s", output_index, workspace_num);

  if (strcmp(action, "focus") == 0) {
    return swaymsg_focus_workspace(workspace_id);
  } else if (strcmp(action, "container-to") == 0) {
    return swaymsg_move_container_to_workspace(workspace_id);
  } else {
    fprintf(stderr, "Unknown action '%s'. Use 'focus' or 'move'.\n", action);
    return 1;
  }
}