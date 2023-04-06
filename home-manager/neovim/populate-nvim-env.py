#!/bin/env python3

import os
from collections import OrderedDict
import argparse
from pathlib import Path

KEYS = [
    # PATH
    "PATH",
    "CS154_ADMIN",
    "BREW_PREFIX",
    "CONDA_PYTHON_EXE",
    "SPACESHIP_ROOT",
    "COLORFGBG",
    "XPC_SERVICE_NAME",
    "_CE_M",
    "XPC_FLAGS",
    "LANG",
    # terminal
    "VISUAL",
    "LESS",
    "LOGNAME",
    "COLORTERM",
    "HISTFILE",
    "LC_TERMINAL",
    "LC_TERMINAL_VERSION",
    "ITERM_SESSION_ID",
    "ITERM_PROFILE",
    "TERM_SESSION_ID",
    "TERM_PROGRAM",
    "STARSHIP_SESSION_KEY",
    "STARSHIP_CONFIG",
    "VI_MODE_SET_CURSOR",
    "_",
    "LSCOLORS",
    "ZSH",
    "EDITOR",
    # XDG
    "XDG_DATA_HOME",
    "XDG_STATE_HOME",
    "XDG_CACHE_HOME",
    "XDG_CONFIG_HOME",
]


def main(args):
    env = os.environ.copy()
    env = OrderedDict(sorted(env.items()))
    dst_file = "{}/env.lua".format(args.output_path)

    openapi_key = None

    if args.openapi_path != "":
        openapi_path = Path(args.openapi_path)
        if openapi_path.exists():
            with open(openapi_path, "r") as f:
                openapi_key = f.readline().strip("\n")

    with open(dst_file, "w") as f:
        for key, value in env.items():
            if key in KEYS:
                if key == "PATH":
                    f.write('vim.env.PATH = vim.env.PATH .. ":{}"\n'.format(value))
                    continue
                f.write('vim.fn.setenv("{}", "{}")\n'.format(key, value))

        if openapi_key is not None:
            f.write('vim.fn.setenv("OPENAI_API_KEY", "{}")\n'.format(openapi_key))

        f.close()


if __name__ == "__main__":
    home_directory = os.path.expanduser("~")
    parser = argparse.ArgumentParser("Neovim Populate Env")
    parser.add_argument("--openapi_path", required=False, type=str, default="")
    parser.add_argument(
        "-o",
        "--output_path",
        required=False,
        help="Output Path",
        type=str,
        default="{}/.config/nvim/lua/rayandrew".format(home_directory),
    )
    args = parser.parse_args()
    main(args)
