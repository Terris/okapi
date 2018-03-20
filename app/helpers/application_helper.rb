module ApplicationHelper

	# Returns the full title on a per-page basis.
	def full_title(page_title)
		base_title = "Okapi"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

	# Returns a date in a nice format
	def nicedate(thedate)
		thedate.strftime("%B %d, %Y")
	end

	# Returns the payment interval with ly (i.e. "weekly")
	def interval_nicename( interval )
		return interval + "ly"
	end
end
