import os
import subprocess
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook

mod = "mod4"
terminal = "alacritty"
emacs = "emacsclient -c -a 'emacs'"
groups = [Group(i) for i in "123456789"]
wmname = "LG3D"
myNormalColor = "#303f9f"
myFocusColor = "#0288d1"
myBorderWidth = 4
myMargin = 5

keys = [
    # Navigate window focus
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows inside layout
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows or reset sizes
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Flip windows
    Key([mod, "shift", "control"], "h", lazy.layout.flip_left(), desc="Flip window to the left"),
    Key([mod, "shift", "control"], "j", lazy.layout.flip_right(), desc="Flip window to the right"),
    Key([mod, "shift", "control"], "k", lazy.layout.flip_down(), desc="Flip window up"),
    Key([mod, "shift", "control"], "l", lazy.layout.flip_up(), desc="Flip window down"),
    # Applications
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "e", lazy.spawn(emacs), desc="Launch Emacs client"),
    Key([mod], "f", lazy.spawn("pcmanfm"), desc="Launch file manager"),
    Key([mod], "l", lazy.spawn("rofi -show combi"), desc="Launch application launcher"),
    Key([mod], "m", lazy.spawn("jgmenu --csv-file='/home/jasonw/.config/jgmenu/menu.csv'"), desc="Launch application menu"),
    # Toggle between layouts
    Key([mod], "Tab", lazy.next_layout(), desc="Next layout"),
    Key([mod, "shift"], "Tab", lazy.prev_layout(), desc="Previous layout"),
    Key([mod], "s", lazy.layout.toggle_split(), desc="Toggle split"),
    # Kill window or toggle floating
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "s", lazy.window.toggle_floating(), desc="Toggle if window is floating"),
    # Qtile commands
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn qtile command prompt"),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

class ThreeColumns(layout.Columns):
      pass

layouts = [
    ThreeColumns(border_normal=myNormalColor, border_focus=myFocusColor, border_width=myBorderWidth, num_columns=3),
    layout.Columns(border_normal=myNormalColor, border_focus=myFocusColor, border_width=myBorderWidth),
    layout.Max(border_normal=myNormalColor, border_focus=myFocusColor, border_width=myBorderWidth, margin=myMargin),
    layout.Bsp(border_normal=myNormalColor, border_focus=myFocusColor, border_width=myBorderWidth, margin_on_single=myMargin),
    layout.Matrix(border_normal=myNormalColor, border_focus=myFocusColor, border_width=myBorderWidth),
    layout.MonadTall(border_normal=myNormalColor, border_focus=myFocusColor, border_width=myBorderWidth),
    layout.MonadWide(border_normal=myNormalColor, border_focus=myFocusColor, border_width=myBorderWidth),
    layout.RatioTile(border_normal=myNormalColor, border_focus=myFocusColor, border_width=myBorderWidth),
    layout.VerticalTile(border_normal=myNormalColor, border_focus=myFocusColor, border_width=myBorderWidth),
    layout.Zoomy(border_normal=myNormalColor, border_focus=myFocusColor, border_width=myBorderWidth),
    layout.Floating(border_normal=myNormalColor, border_focus=myFocusColor, border_width=myBorderWidth),
    layout.Spiral(border_normal=myNormalColor, border_focus=myFocusColor, border_width=myBorderWidth)
]

floating_layout = layout.Floating(
    float_rules=[
	# Run the utility of `xprop` to see the wm class and name of an X client.
	*layout.Floating.default_float_rules,
	Match(wm_class="confirmreset"),  # gitk
	Match(wm_class="makebranch"),  # gitk
	Match(wm_class="maketag"),  # gitk
	Match(wm_class="ssh-askpass"),  # ssh-askpass
	Match(title="branchdialog"),  # gitk
	Match(title="pinentry"),  # GPG key password entry
    ]
)

screens = [
    Screen(
	bottom=bar.Bar(
	    [
		widget.CurrentLayoutIcon(custom_icon_paths=["/home/jasonw/.config/qtile/layout-icons/"]),
		widget.CurrentLayout(font="Adobe Utopia Bold"),
		widget.GroupBox(font="Adobe Courier Bold"),
		widget.Prompt(),
		widget.WindowName(font="Adobe Utopia Bold"),
		widget.Notify(font="Adobe New Century Schoolbook"),
		widget.CheckUpdates(distro="Arch_yay", initial_text="Checking for updates...", colour_have_updates="ffaa00", foreground="ff0000"),
		widget.CPU(foreground="00aaff", font="Hack Bold"),
		widget.Memory(foreground="00ff00", font="Hack Bold"),
		widget.Systray(padding=10),
		widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
	    ],
	    30,
	    # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
	    # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
	    # background="#A7F9FB",
	    opacity=0.7,
	),
    ),
]

widget_defaults = dict(
    font="Adobe Courier Bold",
    fontsize=13,
    padding=5,
)
extension_defaults = widget_defaults.copy()

@hook.subscribe.startup_once
def my_startup_once():
    script = os.path.expanduser('~/.config/qtile/startup_once.sh')
    subprocess.Popen([script])
