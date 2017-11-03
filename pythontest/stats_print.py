import sys
import numpy as np 
import StringIO
import sys
import operator
import json
import tabulate
def main():
    table = []
    for x in sys.argv[1:]:
        f = json.load(open(x,"rb"))
        table.append([f["test"],f["implementation"],f.get("simulation_mode",""),"gpu" if f["gpu"] else "","singlecore" if f.get("single_core",False) else "",f["accuracy"],f["cm_Fscore"],f["training_time"],f["testing_time"]])
    table.sort(key = operator.itemgetter(0,1,2,3,4))

    print tabulate.tabulate(table, headers=["test","impl","GPU","sim_mode","single","accuracy","Fscore","training time","testing time"])

if __name__ == '__main__':
    main()