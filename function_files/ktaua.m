%% Mann-Kendall Tau (aka Tau-b) with Sen's Method (enhanced)
% A non-parametric monotonic trend test computing Mann-Kendall Tau, Tau-b, 
% and Sen’s Slope written in Mathworks-MATLAB implemented using matrix
% rotations.
%
% Suggested citation:
%
% Burkey, Jeff. May 2006.  A non-parametric monotonic trend test computing 
%      Mann-Kendall Tau, Tau-b, and Sen’s Slope written in Mathworks-MATLAB 
%      implemented using matrix rotations. King County, Department of Natural 
%      Resources and Parks, Science and Technical Services section.  
%      Seattle, Washington. USA. 
%      http://www.mathworks.com/matlabcentral/fileexchange/authors/23983
%
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
% Important Note:
%      I have also posted a Seasonal Kendell function at Mathworks
%             sktt.m
%
%http://www.mathworks.com/matlabcentral/fileexchange/22389-seasonal-kendall
%-test-with-slope-for-serial-dependent-data
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
%   revised 12/1/2008- Computed variance now takes into account ties in the
%      time index with multiple observations per index.
%      Added in confidence intervals for Sens Slope
%
% Syntax:
%     [taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3]
%               = ktaub(datain, alpha, wantplot)
%
% where:
%     datain = (N x 2) double
%     alpha = (scalar) double
%     wantplot is a flag
%             ~= 0 means create plot, otherwise do not plot
%
%     taub = Mann-Kendall coefficient adjusted for ties
%     tau = Mann-Kendall coefficient not adjusted for ties
%                n(n-1)/2
%     h = hypothesis test (h=1 : is significant)
%     sig = p value (two tailed)
%     Z = Z score
%     sigma = standard deviation
%     sen = sen's slope
%     plotofslope = data used to plot data and sen's slope
%     cilower = lower confidence interval for sen's slope
%     ciupper = upper confidence interval for sen's slope
%
% These next two variables are output because they are needed in the
% Seasonal Kendall function: sktt.m
%     D = denominator used for calculating Tau-b
%     Dall = denominator used for calculating Tau
%     C3 = individual seasonal slopes aggregated for Sens Seasonal Slope
%     nsigma = an assumed variance with all ties reconsidered but set to
%              equal number of positive and negative differences.
%
%
% Modifications:
% 12/1/2008 - Taub = denominator is adjusted
%             Tau  = denominator is NOT adjusted
%                    (matches USGS Kendall.exe output)
%
% 1/17/2009 - checks for anomalies and provides solutions and/or
%             notifications.  In support of this for the Seasonal Kendall
%             (which was also updated 1/17/2009), another term was added to
%             the output of this function-- nsigma.
%
% 6/15/2011 - updated plotting confidence intervals on Sen's slope.  I
%             don't recall my source on developing it, so use at your own
%             peril. That said using the 95/5 percentiles of the comptued
%             individual slopes seems to be reasonable-- I just don't have
%             a paper to back it up.
%
% 7/23/2011 - added a test for matlab version.
%
% 8/21/2013 - added citation supporting method of computing confidence
%             intervals for Sen's slope. Thanks goes to Dr. Jeff Thompson 
%             for providing the source that backs up my ginned up method 
%             (Line 320). 
%
% When calculating trends, there are a few situations that create anomalies
% in the estimates. Foremost, when S = 0, significance will always be
% 100-percent, which is not possible. When this occurs the p-value is
% adjusted by using the computed variance, but assuming S = 1.  However,
% the output from the function will still show S=0 when the case arises.
%
% Secondly, a statistically significant slope = 0 can occur when there are
% a large number of ties in the data.  In this case, a second test is done
% assuming the number of ties is equal an even number positive and negative
% differences.  Significance is tested again, but the output is only sent
% to the screen.  The p-value returned in the function is still the
% original p-value (and the adjusted p-value for serial correlation).
%
% Kendall Tau-b is useful when there are a significant number of
% artificially induced tied values.  For example, water quality data that
% has infilled non-detects with half MDL's.  This would create a false
% number of ties simply because of the common technique of infilling an
% unknown quantity with a known estimate of a quantity.
%
% These test for anomalies and solutions are based on an unpublished paper:
%
% Anomalies and remedies in non-parametric seasonal trend tests and
% estimates by Graham McBride, National Institute of Water & Atmospheric
% Research, Hamilton New Zealand.  March 2000.
%
%
%  Note:  if data are not temporally evenly spaced, Sen's slope becomes
%  inaccurate (a future TODO).
%
% Requirements: Statistics Toolbox
%     or comment out ztest and manually determine significance
%
% This function is coded without any loops. While this is extremely fast,
% it does have some limitations to computer memory. For example, if a data
% set is around 10,000 in length, 1.0 GB RAM may or may not work.
%
% However, I would imagine if memory is a problem for someone with large
% datasets, a person could convert the necessary variables and statements
% to work with sparse matrices.  Which may slow down this function on
% smaller datasets, but the memory issue would greatly diminish.
%
% Sen's methodology was added in by Curtis DeGasperi- King County, DNRP.
%  reference: Statistical Methods for Environmental Pollution Monitoring,
%  Richard O. Gilbert 1987, ISBN: 0-442-23050-8
%
% A couple of resources for Mann-Kendall statistics.
%
%  Statistical Methods in Water Resources
%   By D.R. Helsel and R.M. Hirsch
%        http://water.usgs.gov/pubs/twri/twri4a3/
%
%  Computer Program for the Kendall Family of Trend Tests
%   by Dennis R. Helsel, David K. Mueller, and James R. Slack
%  Scientific Investigations Report 2005-5275
%  http://pubs.usgs.gov/sir/2005/5275/downloads/
%
%
% Written by Jeff Burkey
% King County, Department of Natural Resources and Parks
% 4/18/2006
% 12/4/2008 (significantly revised)
% email: jeff.burkey@kingcounty.gov
%
% BRG edits
% Removed all components not related to the calculation of taua
%
% [taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3] = ktaub(datain, alpha, wantplot)
function tau = ktaua(datain)
   
    % Data are assumed to be in long columns, hence 'sortrows'
    sorted = sortrows(datain,1);
    % remove any NaNs, if data are missing they should not be included as
    % NaNs.
    sorted(any(isnan(sorted),2),:) = [];
      
    % extract out the data
    row1 = sorted(:,1)';
    row2 = sorted(:,2)';
    
    clear sorted;
    
    L1 = length(row1);
    L2 = L1 - 1;
       
    clear ta tb b e;
       
    % create matricies to be used for substituting values as indicies
    m1 = repmat((1:L2)',[1 L2]);
    m2 = repmat((2:L1)',[1 L2])';
    
    % populate matrixes for analysis
    A1 = triu(row1(m1));
    A2 = triu(row1(m2));
    B1 = triu(row2(m1));
    B2 = triu(row2(m2));
    
    clear m1 m2 row1 row2;
    
    % Perform pair comparison and convert to sign
    A = sign(A1 - A2);
    B = sign(B1 - B2);
       
    clear A1 A2 B1 B2 A3 B3 a;
    
    %% Evaluate concordant and discordant
    % +1 = concordant
    % -1 = discordant
    %  0 = tie
    C = A.*B;
    % Compute S
    S = sum(sum(C,2));
    
    clear A B C;

    % Calcuation denominator no ties removed Tau
    Dall = L1 * (L1 - 1) / 2;
    
    % (modified 12/1/2008: added tau)
    tau = S / Dall;
  