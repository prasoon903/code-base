TotalCount = 5
dictInnerLoop = dict()
Schedule = dict()
for InnerLoop in range(TotalCount):
    dictInnerLoop[InnerLoop] = {}

    dictInnerLoop[InnerLoop]["Terms"] = InnerLoop
    dictInnerLoop[InnerLoop]["TotalTerms"] = TotalCount
    dictInnerLoop[InnerLoop]["Amount"] = InnerLoop * 10


print(dictInnerLoop[0])