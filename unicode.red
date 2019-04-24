Red [
	Author: "Toomas Vooglaid"
	Date: 2017-12-16
	Needs: %range.red
	Needs-Gist: https://gist.github.com/toomasv/0e3244375afbedce89b3719c8be7eac0
]
do %range.red
syms:  load %symbols
dings: load %dingbats
context [
	md: make font! [name: "Consolas" size: 12 color: black]
	ft: make font! [name: "Code2003" size: 36 color: black];EversonMono;Lucida Sans Unicode;Unifont;Tahoma;Symbola
	dc: make font! [name: "Consolas" size: 8  color: 0.0.150]
	hx: make font! [name: "Consolas" size: 8  color: 0.150.0]
	h: "0123456789ABCDEF"
	dr: copy []
	dx: 60 dy: 65
	chars: copy []
	lastchar: firstchar: none
	char-set: none
	codes: none
	chart: none
	make-draw: function [chars][
		k: i: oldi: 0
		oldhey: none
		append clear dr [font hx]
		forall h [
			x: (index? h) - 1 * dx + 61
			append dr compose [text (as-pair x 2) (to-string h/1)]
		]
		forall chars [
			hex: pad/left/with to-string to-hex to-integer chars/1 8 #"0" ; enbase/base to-binary chars/1 16
			j: to-integer debase/base append copy "0" take/last hex 16
			x: j * dx + 40
			hey: skip hex 2
			either 1 = index? chars [
				oldhey: hey
			][
				if oldhey <> hey [oldhey: hey i: i + 1]
			]
			either i < 9 [
				y: i * dy + 20
				if any [1 = index? chars oldi <> i][
					oldi: i
					append dr compose [font hx text (as-pair 2 y + 19) (hey)]
				]
				append dr compose [font ft text (as-pair x y) (to-string chars/1)]
				append dr compose [font dc text (as-pair x y + 57) (
					st: to-string to-integer chars/1 
					pad/left st 8 - (8 - (length? st) / 2)
				)]
			][
				self/lastchar: to-integer first back chars 
				break
			]
		]
		;write/append %debug dr
		dr
	]
	scripts: #(
		latin:				[#0000   #007F]
		ascii: 				[#0020   #007E]
		latin-1_supplement: [#0080   #00FF]
		latin-extA:			[#0100   #017F]
		latin-extB:			[#0180   #024F]
		greek:				[#0370   #03FF]
		cyrillic: 			[#0400   #04FF]
		hebrew:				[#0590   #05FF]
		arabic:				[#0600   #06FF]
		devenagari:			[#0900   #097F]
		georgian:			[#10A0   #10FF]
		hangul-jamo:		[#1100   #11FF]
		latin-additional:	[#1E00   #1EFF]
		hiragana:			[#3040   #309F]
		katakana:			[#30A0   #30FF]
		cjk:				[#4E00   #9FFF]
	)
	symbols: #(
		punctuation:		[#2000   #206F]
		currency:			[#20A0   #20CF]
		letterlike: 		[#2100   #214F]
		arrows: 			[#2190   #21FF]
		math-ops:			[#2200   #22FF]
		technical:			[#2300   #23FF]
		box-drawing:		[#2500   #257F]
		block-elements:		[#2580   #259F]
		geometric: 			[#25A0   #25FF]
		symbols:			[#2600   #26FF]
		dingbats:			[#2700   #27BF]
		arrows-symbols:		[#2B00   #2BFF]
	)
	collections: #(
		weather:			[#2600   #2609]
		pointing:			[#261A   #261F]
		religion:			[#2626   #262F]
		trigrams:			[#2630   #2637]
		astrology:			[#263D   #2647]
		zodiac:				[#2648   #2653]
		chess: 				[#2654   #265F]
		card-suite:			[#2660   #2667]
		musical:			[#2669   #266F]
		dice:				[#2680   #2685]
		mono-digrams:		[#268A   #268F]
		checkers:			[#26C0   #26C3]
		map:				[#26E8   #26FF]
		math-A:				[#27C0   #27EF]
		math-B:				[#2980   #29FF]
		math-ops-suppl:		[#2A00   #2AFF]
		hexagrams:			[#4DC0   #4DFF]
		domino:				[#01F030 #01F09F]
		cards:				[#01F0A0 #01F0FF]
		picts:				[#01F300 #01F5FF]
		emoticons:			[#01F600 #01F64F]
		traffic:			[#01F680 #01F6FF]
		alchemy:			[#01F700 #01F77F]
		geometric-ext:		[#01F780 #01F7FF]
		picts2:				[#01F900 #01F9FF]
	)
	lists: copy []
	show_: func [chars][
		view append compose/deep [
			chart: base 1000x610 white
				draw [(make-draw chars)]
			at 995x10  button 15x15 "˄" [face/enabled?: not 0 >= chars/1 chart/draw: copy make-draw unicode/back 144]
			;at 995x25  scr-bar: button 15x595
			at 995x605 button 15x15 "˅" [chart/draw: copy make-draw unicode/next 144]
			below 
			drop-list 200x20 font md
				data ["Code2003" "EversonMono" "Lucida Sans Unicode" "Symbola" "Tahoma" "Unifont"]
				select 1
				on-change [
					ft/name: pick face/data face/selected 
					show chart/draw
					fdrop: take pos: at face/parent/pane 4
					insert pos flist: make fdrop [type: 'text-list size: 200x115]
				]
		] foreach l [scripts symbols collections] [
			append lists compose/deep [
				drop-list 200x20 font md 
					data [(split form keys-of get l #" ")]
					on-change [chart/draw: copy make-draw unicode to-word pick face/data face/selected]
			]
		]
	]
	to-codes: function [block][
		out: copy []
		parse block [some [s:
			if (s/2 = '-) (append out range type s/1 type s/3) 3 skip
		|	(append out type s/1) skip
		]]
		out
	]
	type: function [val][
		switch type?/word val [
			char!		[to-integer val]
			word! 		[to-integer debase/base skip to-string val 2 16]; 'U+hex
			integer! 	[val] 
			binary! 	[to-integer to-char val] 						; utf-8
			issue!		[to-integer debase/base to-string val 16] 		; Hex
			block!		[self/codes: to-codes val first codes] 			; Ranges can be represented with `-`
		]
	]
	filter: function [series [series!] fn [any-function!]][
		out: make type? series []
		i: spec-of :fn ; `fn` spec should include only words
		foreach (i) series compose [if res: fn (i) [append/only out res]]
		out
	]
	set 'unicode function [val /from lower /to upper /limit lim /next /back /chart /explain][
		self/codes: none
		switch val [
			show 	 [chart: true self/char-set: val: 'latin]
			pages 	 [
				print "List of pages:" 
				return collect [foreach page [scripts symbols collections][
					probe page
					foreach i s: keys-of get page [prin "   " print i keep i] 
				]]
			]
			all-symbols  [
				print "List of symbols:" foreach i s: sort extract syms 2 [prin "   " print i]
				print "List of dingbats:" foreach i d: sort extract dings 2 [prin "   " print i] 
				return reduce [s d]
			]
		]
		if word? v: val [
			either vals: any [scripts/:val symbols/:val collections/:val][
				set [val upper] vals
			][
				probe "failure"
			]
		]
		if string? v: val [
			val: any [select syms val select dings val]
			unless val [
				out: copy []
				foreach symset [syms dings][
					either empty? sym: filter get/any symset func [nam num][if n: find nam v [reduce [head nam num]]][
						if explain [print [symset "does not include simlar names."]]
						;foreach [s n] get/any symset [print [tab to-char n tab s]]
					][
						if explain [print [symset "includes similar names:"]]
						forall sym [if explain [print [tab sym/1/1]] append out sym/1/2]
					]
				]
				self/codes: out;return out
			]
		]
		all [next upper: either integer? val [lastchar + val][val] val: lastchar + 1]
		all [back val: either integer? val [firstchar - val][firstchar - 1] upper: firstchar - 1]
		val: type val
		all [from val: val + type lower]
		all [limit upper: val + lim - 1]
		upper: type any [upper either codes [last codes][val]]
		;probe type upper 
		set [firstchar lastchar] reduce [val upper]
		self/codes: any [codes range val upper]
		collect/into [foreach i codes [keep to-char i]] clear chars 
		either chart [show_ chars][chars]
	]
]

