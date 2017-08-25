source('util.R')

## Gene expression profile data to be loaded
datasets <- c('TCGA.RData',
              'GSE26712.RData',
              'GSE18520.RData',
              'GSE32062.RData',
              'GSE17260.RData',
              'GSE13876.RData',
              'GSE19829.RData',
              'GSE9891.RData',
              'E-MTAB-386.RData')

## Create list variables: X, y, c
## X[[i]] is a matrix of GEP with sample in rows and genes in columns
## y[[i]] is a vector of survival time in days
## c[[i]] is a vector of survival status (1=dead, 0=alive)
X <- list()
y <- list()
c <- list()
for (i in 1:length(datasets)) {
  load(datasets[[i]])
  X[[i]] <- expr
  y[[i]] <- days
  c[[i]] <- status
}

## If multiple columns correspond to the same gene, select one of them
X <- lapply(X, collapse_genes)

## keep common genes across datasets
common.genes <- Reduce(intersect, lapply(X, colnames))
X <- lapply(X, function(x) x[,common.genes])

## transform gene expression to percentile ranks
require(copula)
X <- lapply(X, function(x) t(pobs(t(x))))

## pvalues for leave-one-dataset-out testing
pvalues <- list()
for (whichval in 1:length(X)) {
  pvalues[[whichval]] <- pval_metaci(X[-whichval],y[-whichval],c[-whichval])
}

## save into matlab file
require(R.matlab)
names(X) <- paste("batch",as.character(1:length(X)),sep="")
names(y) <- paste("batch",as.character(1:length(X)),sep="")
names(c) <- paste("batch",as.character(1:length(X)),sep="")
names(pvalues) <- paste("batch",as.character(1:length(X)),sep="")
writeMat("surv_os_ovary_rank_ci.mat",dat=X,days=y,status=c,pvalues=pvalues)

