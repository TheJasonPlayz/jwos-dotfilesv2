(list ;(channel
       ;(name `jwos-channel)
       ;(url "file://home/jasonw/.config/guix/jwos-channel"))
      (channel
       (name 'nonguix)
       (url "https://gitlab.com/nonguix/nonguix"))
      (channel
       (name 'guix)
       (url "https://git.savannah.gnu.org/git/guix.git")
       (introduction
	(make-channel-introduction
	 "9edb3f66fd807b096b48283debdcddccfea34bad"
	 (openpgp-fingerprint
	  "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))
