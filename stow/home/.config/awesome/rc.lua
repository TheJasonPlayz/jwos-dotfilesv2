pcall(rquire, "luarocks.loader")
local gears = require("gears")
local awful = require("awful") 
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty") 
local menubar = require("menubar") 
local hotkeys_popup = require("awful.hotkeys_popup") -- Hotkeys help widget
require("awful.hotkeys_popup.keys")
require("awful.autofocus")

if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
		    title = "Oops, there were errors during startup!",
		    text = awesome.startup_errors })
end

do
   local in_error = false
   awesome.connect_signal("debug::error", function (err)
			     -- Make sure we don't go into an endless error loop
			     if in_error then return end
			     in_error = true

			     naughty.notify({ preset = naughty.config.presets.critical,
					      title = "Oops, an error happened!",
					      text = tostring(err) })
			     in_error = false
   end)
end

beautiful.init("/home/jasonw/.config/awesome/theme.lua")

terminal = "alacritty"
editor = "emacsclient -c -a 'emacs'"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

-- Table of layouts
awful.layout.layouts = {
   awful.layout.suit.floating,
   awful.layout.suit.tile,
   awful.layout.suit.tile.left,
   awful.layout.suit.tile.bottom,
   awful.layout.suit.tile.top,
   awful.layout.suit.fair,
   awful.layout.suit.fair.horizontal,
   awful.layout.suit.spiral,
   awful.layout.suit.spiral.dwindle,
   awful.layout.suit.max,
   awful.layout.suit.max.fullscreen,
   awful.layout.suit.magnifier,
   awful.layout.suit.corner.nw,
   -- awful.layout.suit.corner.ne,
   -- awful.layout.suit.corner.sw,
   -- awful.layout.suit.corner.se,
}

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
				     menu = mymainmenu })

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
			     { "open terminal", terminal }
}
		       })

myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local taglist_buttons = gears.table.join(
   awful.button({ }, 1, function(t) t:view_only() end),
   awful.button({ modkey }, 1, function(t)
	 if client.focus then
	    client.focus:move_to_tag(t)
	 end
   end),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, function(t)
	 if client.focus then
	    client.focus:toggle_tag(t)
	 end
   end),
   awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
   awful.button({ }, 1, function (c)
	 if c == client.focus then
	    c.minimized = true
	 else
	    c:emit_signal(
	       "request::activate",
	       "tasklist",
	       {raise = true}
	    )
	 end
   end),
   awful.button({ }, 3, function()
	 awful.menu.client_list({ theme = { width = 250 } })
   end),
   awful.button({ }, 4, function ()
	 awful.client.focus.byidx(1)
   end),
   awful.button({ }, 5, function ()
	 awful.client.focus.byidx(-1)
end))

mytextclock = wibox.widget.textclock()

awful.screen.connect_for_each_screen(function(s)
      awful.spawn.with_shell("nitrogen --restore &")

      local names = { "main", "chat", "www", "hack1", "hack2", "img", "vid", "8", "9"}
      local l = awful.layout.suit 
      local layouts = { l.floating, l.tile, l.ffair, l.spiral, l.spiral.dwindle,
			l.max, l.magnifier, l.corner.nw}
      awful.tag(names, s, layouts)

      s.mylayoutbox = awful.widget.layoutbox(s)
      s.mylayoutbox:buttons(gears.table.join(
			       awful.button({ }, 1, function () awful.layout.inc( 1) end),
			       awful.button({ }, 3, function () awful.layout.inc(-1) end),
			       awful.button({ }, 4, function () awful.layout.inc( 1) end),
			       awful.button({ }, 5, function () awful.layout.inc(-1) end)))
      s.mytaglist = awful.widget.taglist {
	 screen  = s,
	 filter  = awful.widget.taglist.filter.all,
	 buttons = taglist_buttons
      }


      s.mytasklist = awful.widget.tasklist {
	 screen  = s,
	 filter  = awful.widget.tasklist.filter.currenttags,
	 buttons = tasklist_buttons
      }

      s.mywibox = awful.wibar({ position = "top", screen = s })

      s.mywibox:setup {
	 layout = wibox.layout.align.horizontal,
	 { -- Left widgets
	    layout = wibox.layout.fixed.horizontal,
	    mylauncher,
	    s.mytaglist,
	 },
	 s.mytasklist, -- Middle widget
	 { -- Right widgets
	    layout = wibox.layout.fixed.horizontal,
	    wibox.widget.systray(),
	    mytextclock,
	    s.mylayoutbox,
	 },
      }
end)

root.buttons(gears.table.join(
		awful.button({ }, 3, function () mymainmenu:toggle() end),
		awful.button({ }, 4, awful.tag.viewnext),
		awful.button({ }, 5, awful.tag.viewprev)
))

clientbuttons = gears.table.join(
   awful.button({ }, 1, function (c)
	 c:emit_signal("request::activate", "mouse_click", {raise = true})
   end),
   awful.button({ modkey }, 1, function (c)
	 c:emit_signal("request::activate", "mouse_click", {raise = true})
	 awful.mouse.client.move(c)
   end),
   awful.button({ modkey }, 3, function (c)
	 c:emit_signal("request::activate", "mouse_click", {raise = true})
	 awful.mouse.client.resize(c)
   end)
)

globalkeys = gears.table.join(

)

clientkeys = gears.table.join(
   awful.key({ modkey,           }, "f",
      function (c)
	 c.fullscreen = not c.fullscreen
	 c:raise()
      end,
      {description = "toggle fullscreen", group = "client"}),
   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
      {description = "close", group = "client"}),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
      {description = "toggle floating", group = "client"}),
   awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
      {description = "move to master", group = "client"}),
   awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
      {description = "move to screen", group = "client"}),
   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
      {description = "toggle keep on top", group = "client"}),
   awful.key({ modkey,           }, "n",
      function (c)
	 -- The client currently has the input focus, so it cannot be
	 -- minimized, since minimized clients can't have the focus.
	 c.minimized = true
      end ,
      {description = "minimize", group = "client"}),
   awful.key({ modkey,           }, "m",
      function (c)
	 c.maximized = not c.maximized
	 c:raise()
      end ,
      {description = "(un)maximize", group = "client"}),
   awful.key({ modkey, "Control" }, "m",
      function (c)
	 c.maximized_vertical = not c.maximized_vertical
	 c:raise()
      end ,
      {description = "(un)maximize vertically", group = "client"}),
   awful.key({ modkey, "Shift"   }, "m",
      function (c)
	 c.maximized_horizontal = not c.maximized_horizontal
	 c:raise()
      end ,
      {description = "(un)maximize horizontally", group = "client"})
)

root.keys(globalkeys)

awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border_width,
		    border_color = beautiful.border_normal,
		    focus = awful.client.focus.filter,
		    raise = true,
		    keys = clientkeys,
		    buttons = clientbuttons,
		    screen = awful.screen.preferred,
		    placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
   },

   -- Floating clients.
   { rule_any = {
	instance = {
	   "DTA",  -- Firefox addon DownThemAll.
	   "copyq",  -- Includes session name in class.
	   "pinentry",
	},
	class = {
	   "Arandr",
	   "Blueman-manager",
	   "Gpick",
	   "Kruler",
	   "MessageWin",  -- kalarm.
	   "Sxiv",
	   "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
	   "Wpa_gui",
	   "veromix",
	   "xtightvncviewer"},

	-- Note that the name property shown in xprop might be set slightly after creation of the client
	-- and the name shown there might not match defined rules here.
	name = {
	   "Event Tester",  -- xev.
	},
	role = {
	   "AlarmWindow",  -- Thunderbird's calendar.
	   "ConfigManager",  -- Thunderbird's about:config.
	   "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
	}
   }, properties = { floating = true }},

   -- Add titlebars to normal clients and dialogs
   { rule_any = {type = { "normal", "dialog" }
		}, properties = { titlebars_enabled = true }
   },

   -- Set Firefox to always map on the tag named "2" on screen 1.
   -- { rule = { class = "Firefox" },
   --   properties = { screen = 1, tag = "2" } },
}

client.connect_signal("request::titlebars", function(c)
			 -- buttons for the titlebar
			 local buttons = gears.table.join(
			    awful.button({ }, 1, function()
				  c:emit_signal("request::activate", "titlebar", {raise = true})
				  awful.mouse.client.move(c)
			    end),
			    awful.button({ }, 3, function()
				  c:emit_signal("request::activate", "titlebar", {raise = true})
				  awful.mouse.client.resize(c)
			    end)
			 )

			 awful.titlebar(c) : setup {
			    { -- Left
			       awful.titlebar.widget.iconwidget(c),
			       buttons = buttons,
			       layout  = wibox.layout.fixed.horizontal
			    },
			    { -- Middle
			       { -- Title
				  align  = "center",
				  widget = awful.titlebar.widget.titlewidget(c)
			       },
			       buttons = buttons,
			       layout  = wibox.layout.flex.horizontal
			    },
			    { -- Right
			       awful.titlebar.widget.floatingbutton (c),
			       awful.titlebar.widget.maximizedbutton(c),
			       awful.titlebar.widget.stickybutton   (c),
			       awful.titlebar.widget.ontopbutton    (c),
			       awful.titlebar.widget.closebutton    (c),
			       layout = wibox.layout.fixed.horizontal()
			    },
			    layout = wibox.layout.align.horizontal
						   }
end)

client.connect_signal("mouse::enter", function(c)
			 c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
