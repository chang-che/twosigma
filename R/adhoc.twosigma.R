##' adhoc.twosigma: Perform the ad hoc method described in TWO-SIGMA paper
##' @export adhoc.twosigma
##' @param count Vector of non-negative integer read counts.
##' @param mean_covar Covariates for the (conditional) mean model. Must be a matrix (without an intercept column) or = 1 to indicate an intercept only model.
##' @param zi_covar Covariates for the zero-inflation model. Must be a matrix (without an intercept column), = 1 to indicate an intercept only model, or = 0 to indicate no zero-inflation model desired.
##' @param id Vector of individual-level ID's. Used as predictor in ANOVA model.
##' @param weights weights, as in glm. Defaults to 1 for all observations and no scaling or centering of weights is performed. Passed into zeroinfl function.
##' @return P-value from the ANOVA F test.

adhoc.twosigma<-function(count,mean_covar,zi_covar,id
                        ,weights=rep(1,length(count))){

  check_twosigma_input(count,mean_covar,zi_covar
    ,mean_re=T,zi_re=T,id=id
    ,disp_covar=NULL)

  form<-create_adhoc_formulas(count,mean_covar,zi_covar)
resid<-residuals(zeroinfl(form,dist="negbin",link="logit"),type="pearson",weights=weights)
     lm1<-lm(resid~id)
     p.val_adhoc<-anova(lm1)$`Pr(>F)`[1]
     return(p.val_adhoc)
}
