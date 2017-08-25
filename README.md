This project contains matlab codes for the decentralized learning framework of meta-survival-analysis for development of robust prognostic models. 

"demo.m" contains a demo code for leave-one-dataset-out testing of the proposed method for 9 ovarian cancer datasets. Before running this code, please run "save2matlab.R" in the "R codes" folder. This will do all the required preprocessing before model training, including:
1) 
2)

The workhorse funciton of our method is "cvMeta.m" which performance cross-validation to select the optimal regularization and return the corresponding estimated coefficients. This function relies on the open source optimization tool L1General by Mark Schmidt which can be freely downloaded at: http://www.cs.ubc.ca/~schmidtm/Software/minFunc.html. The sources codes for L1General is also included here for convenience. The L1General folder as well as its subfolders needs to be added to the search path in matlab. 

