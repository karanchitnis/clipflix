class Suggestion < ActionMailer::Base
	default :to => "karanchitnis92@gmail.com"

	def suggestion_box(static_page)
		@static_page = static_page
		#File.open("testing.txt", 'w') {|f| f.write(static_page.from) }
		mail(:from => "static_page.from", :subject => static_page.subject, :body => static_page.body)
	end
end