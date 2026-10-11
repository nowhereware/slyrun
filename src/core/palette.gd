class_name Palette
extends RefCounted

# Colors from the Slyrun website (site/index.html :root and its keycap styles).
# Use these instead of hex values in scripts. assets/ui/theme.tres holds the same
# values for the keycap styles, so change both together.

# Dark keycaps (.key, .cap.dark, .mini)
const CAP_TOP := Color("#272727")
const CAP_BOT := Color("#1B1B1B")
const CAP_LIP := Color("#0F0F0F")
const CAP_BORDER := Color("#2F2F2F")
const CAP_SHADOW := Color("#0B0B0B")

# Text on dark keycaps
const LEGEND := Color("#D2CFCB")
const LEGEND_DIM := Color("#8E8A86")
const TEXT_BRIGHT := Color("#F4F1EE")
const TEXT_DIM := Color("#6F6A64")
const NEXT_WORD := Color("#8A847E")

# Orange keys and accents
const ORANGE := Color("#DA4B12")
const ORANGE_HI := Color("#EC5F22")
const ORANGE_LO := Color("#A8380B")
const ORANGE_INK := Color("#C2410C")
const KEY_LETTER := Color("#FFF5EC")

# Light keys (.start, .btn)
const LIGHT_TOP := Color("#FFFFFF")
const LIGHT_BOT := Color("#F4F3F1")
const LIGHT_BORDER := Color("#8F8C88")
const LIGHT_SHADOW := Color("#B9B6B2")

# Light cards (.cap) and the text on them
const INK := Color("#1E1B19")
const MUTED := Color("#5E5954")
const CARD_BORDER := Color("#CFCAC4")

# Text on the brown ground (.more, the footer)
const CREAM := Color("#F3E9DD")

const NIGHT := Color("#0E0D0C")
# Not on the website: a red warm enough to sit next to the oranges. Orange already means
# "current letter", so typos need their own color.
const TYPO := Color("#E5484D")
