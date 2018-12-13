collection = 'state-lhp'
pidStart = 10786
pidEnd = 10856
pids = range(pidStart, pidEnd)

outFile = open(collection + '_pids.txt' , 'w')

outFile.write(collection + ':')
outFile.write(('\n' + collection + ':').join(str(pid) for pid in pids))

outFile.close()
