#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int swaymsg(int argc, char *argv[]) {
  char cmd[4096] = "swaymsg";
  for (int i = 0; i < argc; i++) {
    strncat(cmd, " ", sizeof(cmd));
    strncat(cmd, argv[i], sizeof(cmd));
  }
  return system(cmd);
}

const char* swaymsg_get_focused_output() {
    static char output[65536];

    FILE *fp = popen("swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name'", "r");
    if (!fp) return "";

    output[0] = '\0';
    size_t total = 0;
    char buf[1024];

    while (fgets(buf, sizeof(buf), fp)) {
        size_t len = strlen(buf);
        if (total + len < sizeof(output) - 1) {
            memcpy(output + total, buf, len);
            total += len;
        }
    }
    output[total] = '\0';

    if (total > 0 && output[total - 1] == '\n')
        output[--total] = '\0';

    pclose(fp);
    return output;
}

int swaymsg_focus_workspace(const char *workspace) {
    char *args[] = { "workspace", (char *)workspace };
    return swaymsg(2, args);
}

int swaymsg_move_container_to_workspace(const char *workspace) {
    char *args[] = { "move", "container", "to", "workspace", (char *)workspace };
    return swaymsg(5, args);
}
