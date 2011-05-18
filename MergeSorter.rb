#Author: Philip Rose & Jan Kuffer
class MergeSorter < AbstractSorter
  
  #Sortierfunktionen
  def sort(seq)
  end
  
  def sort(seq,sortBlock)
  end
  
  def performSort
    @accessCount = 0
    @compareCount = 0
    @initTime = Time.now
    @outputSeq = sortBetween(0, @outputSeq.length - 1)
  end
 
  
  def createPartList(index1,index2)
    resultList = []
    
    index1.upto(index2) do |i|
      resultList.push(self.[](i))
    end
    
    return resultList
  end
 
  def sortBetween(index1,index2)
    if(compare(index1, index2) == 0) then return createPartList(index1,index2) end
          
    cutter = (index1 + index2) / 2
    linkeListe = sortBetween(index1, cutter)
    rechteListe = sortBetween(cutter + 1, index2)
    
    return merge(linkeListe, rechteListe)
  end
   
  def merge(left, right)
    resultList = []
  
    while (less(0, left.length) and less(0, right.length))
      if(compare(left[0], right[0]) <= 0) then
        resultList.push(left[0])
        left.delete_at(0)
      else
        resultList.push(right[0])
        right.delete_at(0)     
      end        
    end
    
    while(less(0, left.length))
      resultList.push(left[0])
      left.delete_at(0)  
    end
    
    while(less(0, right.length))
      resultList.push(right[0])
      right.delete_at(0)  
    end
    
    return resultList    
  end
end