# Tennessee Campaign Finance Data

The Tennessee State Legislature has a public Campaign Finance website, in theory
to ensure transparency in our elected officials.   In practice, the website was
deliberately crippled to make it tedious and difficult to use, in order to deter
users from actually using it for its intended purpose.

I've been dealing with this for years, and got fed up with it a couple months
ago.   Since it's public data and I have zero faith that the TN Legislature will
voluntarily improve their transparency, I decided to do it myself by downloading
the data on the "Contributions and Expenditures" page one spreadsheet at a time,
organizing, and merging them together.  This required downloading, stitching 
together, sanity-checking, and cleaning over 500 spreadsheets of data.  That was
absolutely zero fun whatsoever, do not recommend at all...

Now you can use modern data analysis tools like R, Tableau, Excel, SQL, or even
"awk | grep | sed" (which is still better than the campaign finance website) to
analyze the entire 20 year dataset from 2000-2020 and see which PACs, business,
elected officials, and individuals are donating to politicians and PACs.  It's 
not perfect, but it's the best we're likely to get until there's a regime change
or someone on the inside dumps the existing database and posts it on Pastebin.

![Contributions to Candidates by Source](https://i.imgur.com/1KVjeBj.png)

There are two different versions of the TN Campaign Finance data available here:

* A "pristine" version.   Take the reports for each year and concatenate them
together.   Added a "Source" = {Candidate, PAC, Business, Individual} and 
"Dest" = {Candidate, Pac} field for Contributions to correspond to the 
equivalent selectors on the website, and a "Source" = {Candidate, PAC, Other}
and "Dest" = {Candidate, Pac} field for Expenditures.   Barring gross error, 
this version is fairly static, though the current and previous year will require
occasional updates as new or late reports are released.

* The "cleaned" version uses the "pristine" version as a base.   I merged all 
years into a single database for {Contributions, Expenditures}, converted two 
different date formats and a bunch of dates with typos into ISO date format to
make searches simpler, converted dollar amounts from a character string to a 
numeric to make analysis easier, and added a "Report.Year" variable that 
corresponds to the reporting year.

# Decompressing the data

To save bandwidth, all files are compressed using the xz compressor.   On Linux
(and presumably Mac, sorry I don't have access to one), just run `xz -d *.xz`
to decompress the files.   On Windows, use [7-Zip](www.7-zip.org) (FREE) to 
decompress.

# Using the data

The files themselves are .csv spreadsheets and can be viewed by any spreadsheet
such as:

   - [LibreOffice Calc](https://www.libreoffice.org/) (FREE)
   - [Microsoft Excel](https://www.microsoft.com/en-us/microsoft-365/excel)
   - [Google Sheets](https://www.google.com/sheets/about/)
   - [Apple iWork Numbers](https://www.apple.com/iwork/)
   
For complex analysis you probably want to use dedicated analysis software like:

   - [RStudio](https://rstudio.com/) (FREE, and what I used)
   - [Tableau Public Edition](https://public.tableau.com/en-us/s/download) (FREE)
   - [Tableau Commercial Version](https://www.tableau.com)
   - [Microsoft Power BI](https://powerbi.microsoft.com/en-us/)
   - [Stata](https://www.stata.com/)
   
In addition, .csv files can be imported into popular databases (SQLite, MySQL, 
PostgreSQL, etc), and then accessed programmatically from your preferred 
language (Python, Perl, Java, C#, etc.)

# How you can help:

* If anyone with website skills wants to put up a public dashboard, I think it
would be quite useful for the public to be able to see who is funding their
elected officials, and who is funding the funders.   Which PACs/Businesses
donate the most money, which candidates receive the most money, and does that
affect the outcome of votes?

* Create ancillary datasets to help bolster the usefulness of this data.   You 
don't have to do them all, but by doing a couple of entries you can help 
contribute.  In particular, it would be useful to have:

   - A spreadsheet for candidates with their party affiliation, office sought, 
     election year, district, PAC if they have one
     
   - A spreadsheet for PACs/businesses with info on their Industry (alcohol, 
     payday loans, real estate, etc), to make it easier to filter contributions
     or expenditures by industry, to see if PAC contribution is affecting 
     legislative outcomes.  


* Mine the data and ask questions.  A few that have occurred to me so far:

   - Look at expenditures and see if candidates are using their campaign money
     for questionable expenses, like "GOLF TOURNAMENT", "BALLOON ARTIST", 
     "AR-15 RIFLES FOR HOGFEST GIVEAWAY", "BBQ PIT PAINT JOB" (yes, those are 
     actual items).
     
   - Do some double-entry accounting to verify that the donations PAC's post on 
     their expenses are matched by contributions reported by the Candidate.
     
   - Look for candidates or donors laundering money by circulating them around
     PACs.
     
   - See if politicians who receive a larger share of their income from 
     PACs/businesses tend to ignore their constituent's wishes.    

There are many interesting questions both journalistic and academic whose 
answers lie within.

* Help pierce the corporate veil of PACs.   It used to be that a individual or
business gave money directly to a candidate.    Now, in order to evade campaign
finance restrictions, money often goes individual -> PAC -> candidate, or even
more complex loops (individual -> PAC_1 -> PAC_2 -> PAC_3 -> Candidate).   The
database has info on individuals/businesses that donate to PACs, PACs that 
donate to other PACs, and PACs that donate to candidates.   Use the data to cut
through the Gordian Knot of PACs so we can get a clearer view on who is donating
to our candidates.

* Help verify the data.   I have done the best I can to check the data, but
there's only so much I can do given how torturous it was to assemble in the
first place.  I have released sha256sums of the downloaded datasets.   The datasets
are labeled 
`{cont,exp}_{year}_{candidate,pac}_{candidate,pac,individual,business,other}_{index}`.  
If you go to the "Contributions and Expenditures" site, select Contribution or 
Expenditures `{cont,exp}`, then the year `{year}`, then whether next selector is 
candidate or pac `{candidate,pac}`, then whether next selector is 
`{candidate,pac,individual,business,other}`, then an index based on page number 
(some have multiple pages so you have to click "MORE" at the bottom to go to the
next page), and always select all the "Display these fields in my results" boxes
at the bottom.   Download a few random ones, take a sha256sum, and compare it to 
the list in Github.   If there is a difference, let me know and I'll fix it.

# FAQ

* **Why did you hack the state government?**

I didn't "hack" the state government.   It's public data and I accessed it
using the same horrible 
[TN Campaign Finance webform](https://apps.tn.gov/tncamp-app/public/search.htm) 
that everyone else uses.  When you do a search, they have an option to "Save as 
Excel" at the bottom.  So I did.  Many, many times.  They make the website
resistant to automating even that part, so I had to download everything by hand
over a couple of months.  Then I reassembled those Excel spreadsheets back into 
something as closely resembling the original database as possible.

* **Why did you release this data?**

The TN State Legislature makes the Campaign Finance report website as difficult
to use as they can get away with.  It is tedious, takes a long time to get 
anywhere, and only offers the data in bite-sized morsels that make it resistant
to easy and/or deep analysis.  I would have greatly preferred if TN had offered 
the public data in a more useful form, but after a decade of people begging them
and nothing happening, it became glaringly obvious that they would not improve
their transparency willingly.

* **How do I use the data?**

The data is simple spreadsheets.  Any spreadsheet (Excel, iWork, OpenOffice, 
LibreOffice) should be able to easily view the files.  But for complex querying
you probably want to use data analysis software like:

   - [RStudio](https://rstudio.com/) (FREE)
   - [Tableau Public Edition](https://public.tableau.com/en-us/s/download) (FREE)
   - [Tableau Commercial Version](https://www.tableau.com)
   - [Microsoft Power BI](https://powerbi.microsoft.com/en-us/)
   - [Stata](https://www.stata.com/)
   
Or you may prefer to import it into a SQL database.   It's bog-standard .csv
and should easily import into SQLite, MySQL, Postgresql, Oracle, and SQL server. 
Once there you should be able to access it using your preferred language
(Python, Perl, Visual Basic, Java, etc.)

* **I think I've found a mistake or missing data!**

Please open a bug report about it, and I'll fix the data as soon as I can.  Give
me as much info as possible. 

* **What's Next?**

I will likely make further revisions to the "cleaned" version, like add a field
for the Legislative Session (112, 110, etc), tweaking Contributor/Recipient
names to make sure they are consistent and have no typos, or splitting the
"Address" fields into "Street", "City", "ZIP" to make searches easier, though I
will leave the original fields intact in case anyone builds apps or workflow
around them.   A lot of these fields have typos of various sorts, and I'm trying
to figure out a way to clean them up.

I also intend to keep this dataset updated whenever new reports are released, as
long as I can do so.

* **I'd like to contribute...**

By all means!   If you write an interesting bit of code or a cool graph, please
submit it and I'll add it up here.

* **I sent you a message and didn't hear back**

I only check Github infrequently, so if you sent me something and haven't heard
back from me in a reasonable time, just PM /u/MetricT on Reddit.

* **You're so awesome!!  How can I repay you?**

Just send me a message telling me how you used the data.  It's always nice to 
hear back from folks, plus you might give me good ideas.

As for something more material, thanks but I'm good.  If you have money burning
a hole in your pocket, donate it to the
[Society of Professional Journalists](https://www.spj.org/donate.asp)
and help support the folks bringing us the news everyday.  

# Thanks...

My thanks to Phil Williams, Tom Humphrey, Erik Schelzig, Natalie Allison, 
Chas Sisk, Sergio Martinez-Beltran, Cari Wade Gervin, Betsy Phillips, and the 
many others local journalists who work long hours and endure endless abuse to 
bring us the news.   

People don't go into reporting for the big bucks.  They do it for passion 
and to make a difference.  And you all do.

Luke 8:17
