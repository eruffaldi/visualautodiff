import numpy as np
#https://i.stack.imgur.com/AuTKP.png
class MulticlassStat:
  def __init__(self,matrix):
    sumall = np.sum(matrix)
    sumall = np.add(sumall,0.00000001) # TP+FP+TN+FN

    TP = np.diagonal(matrix)

    sumrow = np.sum(matrix,axis=1)
    sumrow = np.add(sumrow,0.00000001) # TP+FP
    uprecision = np.divide(TP,sumrow) # TP/(TP+FP)

    sumcol = np.sum(matrix,axis=0)
    sumcol = np.add(sumcol,0.00000001) # TP+FN
    urecall = np.divide(TP,sumcol) # TP/(TP+FN)

    FP = sumrow-TP
    FN = sumcol-TP
    #TN = sumall-FP-FN-TP

    ufpr = np.divide(FP,sumrow) # FP/(FP+FN)

    self.TP = TP
    self.FP = FP
    self.FN = FN
    #self.TN = TN
    self.accuracy = np.sum(TP)/sumall # (TP+TN)/all
    self.precision = np.sum(uprecision)/uprecision.shape[0] # TP/(TP+FP) aka positive predictive value PPV
    self.recall = np.sum(urecall)/urecall.shape[0] # TP / (TP+FN)  aka sensitivity aka hit rate aka true positive rate TPR
    self.fpr = np.sum(ufpr)/ufpr.shape[0] 
    self.specificity = 1-self.fpr # TN/(TN+FP) aka true negative rate (TNR) === 1-FPR ==  fall out or false positive rate FP/(FP+TP)
    self.Fscore  = (2*self.precision*self.recall)/(self.precision+self.recall) # 2*precision*recall/(precision+recall)
    self.fpr_all = ufpr
    self.tpr_all = urecall
    self.tpr = self.recall
