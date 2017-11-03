
import sys
import numpy as np 
import json
import base64
import StringIO
from itertools import cycle
import matplotlib.pyplot as plt
import sys
from sklearn.metrics import roc_curve, auc
from scipy import interp
from confusionmatrixinfo import *

# http://scikit-learn.org/stable/auto_examples/model_selection/plot_roc.html
def oneclass_decision_function_to_roc(y_test,y_score,n_classes):
    # Compute ROC curve and ROC area for each class
    fpr = dict()
    tpr = dict()
    roc_auc = dict()
    for i in range(n_classes):
        fpr[i], tpr[i], _ = roc_curve(y_test[:, i], y_score[:, i])
        roc_auc[i] = auc(fpr[i], tpr[i])


    return dict(fpr=fpr,tpr=tpr,roc_auc=roc_auc)



# http://scikit-learn.org/stable/auto_examples/model_selection/plot_roc.html
def plotmulticlass(n_classes,fpr,tpr,roc_auc):
    # Compute macro-average ROC curve and ROC area
    lw = 2
    # First aggregate all false positive rates
    all_fpr = np.unique(np.concatenate([fpr[i] for i in range(n_classes)]))

    # Then interpolate all ROC curves at this points
    mean_tpr = np.zeros_like(all_fpr)
    for i in range(n_classes):
        mean_tpr += interp(all_fpr, fpr[i], tpr[i])

    # Finally average it and compute AUC
    mean_tpr /= n_classes

    fpr["macro"] = all_fpr
    tpr["macro"] = mean_tpr
    roc_auc["macro"] = auc(fpr["macro"], tpr["macro"])


    plt.figure()
    plt.plot(fpr["micro"], tpr["micro"],
             label='micro-average ROC curve (area = {0:0.2f})'
                   ''.format(roc_auc["micro"]),
             color='deeppink', linestyle=':', linewidth=4)

    plt.plot(fpr["macro"], tpr["macro"],
             label='macro-average ROC curve (area = {0:0.2f})'
                   ''.format(roc_auc["macro"]),
             color='navy', linestyle=':', linewidth=4)

    colors = cycle(['aqua', 'darkorange', 'cornflowerblue'])
    for i, color in zip(range(n_classes), colors):
        plt.plot(fpr[i], tpr[i], color=color, lw=lw,
                 label='ROC curve of class {0} (area = {1:0.2f})'
                 ''.format(i, roc_auc[i]))

    plt.plot([0, 1], [0, 1], 'k--', lw=lw)
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Some extension of Receiver operating characteristic to multi-class')
    plt.legend(loc="lower right")

# http://scikit-learn.org/stable/auto_examples/model_selection/plot_roc.html
def confusion_matrix_to_roc(cm):
    # Compute ROC curve and ROC area for each class
    mm = MulticlassStat(cm)
    fpr = dict()
    tpr = dict()
    roc_auc = dict()
    n_classes = cm.shape[0]
    for i in range(n_classes):
        # emulate h
        fpr[i] = [0,mm.fpr_all[i],1]
        tpr[i] = [0,mm.tpr_all[i],1]
        roc_auc[i] = auc(fpr[i], tpr[i])

    fpr["micro"] = [0,mm.fpr,1]
    tpr["micro"] = [0,mm.tpr,1]
    roc_auc["micro"] = auc(fpr["micro"], tpr["micro"])

    return dict(fpr=fpr,tpr=tpr,roc_auc=roc_auc)
    
#https://www.iterm2.com/utilities/imgls
def encode_iterm2_image(data,height=None):
    if height is None:
        height = "auto"
    else:
        height = "%spx" % height
    return ("\x1B]1337;File=loss.jpg;width=auto;height=%s;inline=1;size=%dpreserveAspectRatio=1:" % (height,len(data))) + base64.b64encode(data) + "\a\033\\"


def main():
    for x in sys.argv[1:]:
        f = json.load(open(x,"rb"))
        cmf = x+".cm.txt"
        cm = np.loadtxt(cmf).astype(np.int32)

        #print mm.fpr_all,mm.tpr_all
        dd = confusion_matrix_to_roc(cm)
        plotmulticlass(10,dd["fpr"],dd["tpr"],dd["roc_auc"])
        buf = StringIO.StringIO()
        plt.savefig(buf,format="png")
        print cmf,f["test"],f["implementation"],"gpu" if f["gpu"] else "","singlecore" if f.get("single_core",False) else ""
        print encode_iterm2_image(buf.getvalue(),200)

if __name__ == '__main__':
    main()