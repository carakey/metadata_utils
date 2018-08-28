collection = 'hnoc-p16313coll17'
pidStart = 8539
pidEnd = 10734
pids = range(pidStart, pidEnd)

outFile = open(collection + '_pids.txt' , 'w')

outFile.write(collection + ':')
outFile.write((',' + collection + ':').join(str(pid) for pid in pids))

outFile.close()