import sys
POL='PQVTLWQRPLVTIKIGGQLKEALLDTGADDTVLEEMSLPGRWKPKMIGGIGGFIKVRQYDQILIEICGHKAIGTVLVGPTPVNIIGRNLLTQIGCTLNFPISPIETVPVKLKPGMDGPKVKQWPLTEEKIKALVEICTEMEKEGKISKIGPENPYNTPVFAIKKKDSTKWRKLVDFRELNKRTQDFWEVQLGIPHPAGLKKKKSVTVLDVGDAYFSVPLDEDFRKYTAFTIPSINNETPGIRYQYNVLPQGWKGSPAIFQSSMTKILEPFRKQNPDIVIYQYMDDLYVGSDLEIGQHRTKIEELRQHLLRWGLTTPDKKHQKEPPFLWMGYELHPDKWTVQPIVLPEKDSWTVNDIQKLVGKLNWASQIYPGIKVRQLCKLLRGTKALTEVIPLTEEAELELAENREILKEPVHGVYYDPSKDLIAEIQKQGQGQWTYQIYQEPFKNLKTGKYARMRGAHTNDVKQLTEAVQKITTESIVIWGKTPKFKLPIQKETWETWWTEYWQATWIPEWEFVNTPPLVKLWYQLEKEPIVGAETFYVDGAANRETKLGKAGYVTNRGRQKVVTLTDTTNQKTELQAIYLALQDSGLEVNIVTDSQYALGIIQAQPDQSESELVNQIIEQLIKKEKVYLAWVPAHKGIGGNEQVDKLVSAGIRKVLFLDGIDKAQDEHEKYHSNWRAMASDFNLPPVVAKEIVASCDKCQLKGEAMHGQVDCSPGIWQLDCTHLEGKVILVAVHVASGYIEAEVIPAETGQETAYFLLKLAGRWPVKTIHTDNGSNFTGATVRAACWWAGIKQEFGIPYNPQSQGVVESMNKELKKIIGQVRDQAEHLKTAVQMAVFIHNFKRKGGIGGYSAGERIVDIIATDIQTKELQKQITKIQNFRVYYRDSRNPLWKGPAKLLWKGEGAVVIQDNSDIKVVPRRKAKIIRDYGKQMAGDDCVASRQDED'

POL_AA_COUNT={}
for i in range(len(POL)):
    AA='ARNDCEQGHILKMFPSTWYV'
    thisDict={}
    for j in AA:
        thisDict[j]=0
    POL_AA_COUNT[i]=thisDict


GATE='close'
infile=open(sys.argv[1])
bucket=''
while 1:
    line=infile.readline().strip()
    if not line:
        break
    if line=='<Iteration>':
        GATE='open'
    if line=='</Hsp>':
        GATE='close'
        if bucket!='' and '<Hit_num>1</Hit_num>' in bucket and '<Hsp_gaps>0</Hsp_gaps>' in bucket:
            POLstart=int(bucket.split('<Hsp_hit-from>')[1].split('</Hsp_hit-from>')[0])-1
            POLend=int(bucket.split('<Hsp_hit-to>')[1].split('</Hsp_hit-to>')[0])
            POLseq=bucket.split('<Hsp_hseq>')[1].split('</Hsp_hseq>')[0]
            READseq=bucket.split('<Hsp_qseq>')[1].split('</Hsp_qseq>')[0]
            POLslice=POL[POLstart:POLend]
            if POLslice==POLseq:
                for i in range(POLstart,POLend):
                    if READseq[i-POLstart] in AA:
                        POL_AA_COUNT[i][READseq[i-POLstart]]+=1
                
                
        bucket=''
        
    if GATE=='open':
        bucket+=line
def chooseMostFreqAA(aDict):
    freqAA=None
    maxCount=0
    for i in aDict:
        if aDict[i]>=maxCount:
            maxCount=aDict[i]
            freqAA=i
    return freqAA, maxCount
    
    
print 'ReferencePosition ReferenceAminoAcid MostFrequentAminoAcid MostFrequentAminoAcidCount TotalAminoAcids FractionOfFrequentAminoAcid '+' '.join(list(AA))
for i in POL_AA_COUNT:
    TotalAminoAcids=sum(POL_AA_COUNT[i].values())
    counts=chooseMostFreqAA(POL_AA_COUNT[i])
    FractionOfFrequentAminoAcid=float(counts[1])/TotalAminoAcids
    print i+1, POL[i], counts[0], counts[1], TotalAminoAcids, FractionOfFrequentAminoAcid,
    for j in AA:
        print POL_AA_COUNT[i][j],
    print 
    
