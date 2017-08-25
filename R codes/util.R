## Compute p-values of each feature based
## on C-Index and Stouffer's meta-z method
require(survcomp)

pval_metaci <- function(X,y,c)
{
  d <- dim(X[[1]])[2]
  pvalue <- vector("numeric",d)
  pb = txtProgressBar(min = 0, max = d, initial = 0,  style = 3) 
  for (i in 1:d)
  {
    setTxtProgressBar(pb,i)
    zscores <- rep(NA,length(X))
    for (j in 1:length(X))
    {
      OS <- y[[j]]
      OSevent <- c[[j]]
      ex <- X[[j]][,i]
      Cobj <- concordance.index(ex,OS,OSevent,method="noether")
      if (!is.na(Cobj$p.value))
      {
        zscores[j] <- sign(Cobj$c.index-0.5)*qnorm(1-(Cobj$p.value)/2)
      }
    }
    z <- zscores[!is.na(zscores)]
    pvalue[i] <- 2*(1-pnorm(abs(sum(z)/sqrt(length(z)))))
  }
  pvalue
}


## Collapse multiple columns of the same gene
## Select the column with the maximum mean
collapse_genes <- function(X)
{
  gene.names <- colnames(X)
  unique.gene.names <- names(table(gene.names))
  idx <- lapply(as.list(unique.gene.names),"==",gene.names)
  for (i in 1:length(idx))
  {
    tmp <- which(idx[[i]])
    if (length(tmp)==1)
      idx[[i]] <- tmp
    else
      idx[[i]] <- tmp[which.max(colMeans(abs(X[,tmp])))]
  }
  X <- X[,unlist(idx)]
}