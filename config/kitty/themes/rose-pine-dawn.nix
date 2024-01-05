{ pkgs }: pkgs.writeText "rose-pine-dawn.conf" ''
  ## name: Rosé Pine Dawn
  ## author: mvllow
  ## license: MIT
  ## upstream: https://github.com/rose-pine/kitty/blob/main/dist/rose-pine-dawn.conf
  ## blurb: All natural pine, faux fur and a bit of soho vibes for the classy minimalist

  foreground               #575279
  background               #faf4ed
  selection_foreground     #575279
  selection_background     #dfdad9

  cursor                   #cecacd
  cursor_text_color        #575279

  url_color                #907aa9

  active_tab_foreground    #575279
  active_tab_background    #f2e9e1
  inactive_tab_foreground  #9893a5
  inactive_tab_background  #faf4ed

  active_border_color      #286983
  inactive_border_color    #dfdad9

  # black
  color0   #f2e9e1
  color8   #9893a5

  # red
  color1   #b4637a
  color9   #b4637a

  # green
  color2   #286983
  color10  #286983

  # yellow
  color3   #ea9d34
  color11  #ea9d34

  # blue
  color4   #56949f
  color12  #56949f

  # magenta
  color5   #907aa9
  color13  #907aa9

  # cyan
  color6   #d7827e
  color14  #d7827e

  # white
  color7   #575279
  color15  #575279
''
