#!/usr/bin/Rscript

cPrecision <- 5


# - numToWord ---------------------------------------------------------------------------------- <<< -

numToWord <- function (num) {

	hlp <- function (n) {		# <<<
		if (n == 1)			"one"
		else if (n == 2)	"two"
		else if (n == 3)	"three"
		else if (n == 4)	"four"
		else if (n == 5)	"five"
		else if (n == 6)	"six"
		else if (n == 7)	"seven"
		else if (n == 8)	"eight"
		else if (n == 9)	"nine"
		else if (n == 10)	"ten"
		else if (n == 11)	"eleven"
		else if (n == 12)	"twelve"
		else if (n == 13)	"thirteen"
		else if (n == 14)	"fourteen"
		else if (n == 15)	"quarter"
		else if (n == 16)	"sixteen"
		else if (n == 17)	"seventeen"
		else if (n == 18)	"eighteen"
		else if (n == 19)	"nineteen"
		else if (n == 20)	"twenty"
		else if (n == 30)	"half"
		else if (n == 40)	"fourty"
		else if (n == 50)	"fifty"
		else	"error"
	}							# >>>

	if (num <= 20) {
		return (hlp (num))
	} else {
		ones <- num %% 10
		tens <- num - ones
		if (ones != 0)
			return (paste (hlp(tens),hlp(ones),sep="-"))
		else
			return (hlp(tens))
	}
}

# ---------------------------------------------------------------------------------------------- >>> -
# - roundUp ------------------------------------------------------------------------------------ <<< -

roundUp <- function (num) {
	mod <- num %% cPrecision
	if (mod < (cPrecision/2))
		return (num-mod)
	else
		return (num-mod+cPrecision)
}

# ---------------------------------------------------------------------------------------------- >>> -
# - timeToWords -------------------------------------------------------------------------------- <<< -

timeToWords <- function (hors, mins) {
	hors <- hors %% 12
	if (mins <= 30) {
		res <- numToWord (mins)
		res <- paste (res, "past")
		res <- paste (res, numToWord (hors))
	} else {
		res <- numToWord (60-mins)
		res <- paste (res, "to")
		res <- paste (res, numToWord (hors+1))
	}
	return (res)
}

# ---------------------------------------------------------------------------------------------- >>> -

curr <- Sys.time()
hors <- as.numeric(format(curr,"%H"))
mins <- roundUp (as.numeric(format(curr,"%M")))

cat (timeToWords (hors, mins))
