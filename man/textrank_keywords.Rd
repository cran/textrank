% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/textrank.R
\name{textrank_keywords}
\alias{textrank_keywords}
\title{Textrank - extract relevant keywords}
\usage{
textrank_keywords(
  x,
  relevant = rep(TRUE, length(x)),
  p = 1/3,
  ngram_max = 5,
  sep = "-"
)
}
\arguments{
\item{x}{a character vector of words.}

\item{relevant}{a logical vector indicating if the word is relevant or not. In the standard textrank
algorithm, this is normally done by doing a Parts of Speech tagging and selecting which of the words are
nouns and adjectives.}

\item{p}{percentage (between 0 and 1) of relevant words to keep. Defaults to 1/3.
Can also be an integer which than indicates how many words to keep. Specify +Inf if you want to keep all words.}

\item{ngram_max}{integer indicating to limit keywords which combine \code{ngram_max} combinations of words which follow one another}

\item{sep}{character string with the separator to \code{paste} the subsequent relevant words together}
}
\value{
an object of class textrank_keywords
which is a list with elements:
\itemize{
\item terms: a character vector of words from the word network with the highest pagerank
\item pagerank: the result of a call to \code{\link[igraph]{page_rank}} on the word network
\item keywords: the data.frame with keywords containing columns keyword, ngram, freq indicating the keywords found and the frequency of occurrence
\item keywords_by_ngram: data.frame with columns keyword, ngram, freq indicating the keywords found and the frequency of occurrence
at each level of ngram. The difference with keywords being that if you have a sequence of words e.g. data science consultant, then in the keywords_by_ngram
you would still have the keywords data analysis and science consultant, while in the keywords list element you would only have data science consultant
}
}
\description{
The textrank algorithm allows to find relevant keywords in text.
Where keywords are a combination of words following each other. \cr

In order to find relevant keywords, the textrank algorithm constructs a word network. This
network is constructed by looking which words follow one another.
A link is set up between two words if they follow one another, the link gets a higher weight if these 2 words occur
more frequenctly next to each other in the text.\cr
On top of the resulting network the 'Pagerank' algorithm is applied to get the importance of each word.
The top 1/3 of all these words are kept and are considered relevant. After this, a keywords table is constructed
by combining the relevant words together if they appear following one another in the text.
}
\examples{
data(joboffer)
keywords <- textrank_keywords(joboffer$lemma,
                              relevant = joboffer$upos \%in\% c("NOUN", "VERB", "ADJ"))
subset(keywords$keywords, ngram > 1 & freq > 1)
keywords <- textrank_keywords(joboffer$lemma,
                              relevant = joboffer$upos \%in\% c("NOUN"),
                              p = 1/2, sep = " ")
subset(keywords$keywords, ngram > 1)

## plotting pagerank to see the relevance of each word
barplot(sort(keywords$pagerank$vector), horiz = TRUE,
        las = 2, cex.names = 0.5, col = "lightblue", xlab = "Pagerank")
}
\seealso{
\code{\link[igraph]{page_rank}}
}
