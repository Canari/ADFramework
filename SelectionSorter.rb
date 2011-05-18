#Author: Philip Rose & Jan Kuffer
class SelectionSorter < AbstractSorter
  
  #Sortierfunktionen
  def sort(seq)
  end
  
  def sort(seq, sortBlock)
  end
  
  def performSort
    @accessCount = 0
    @compareCount = 0
    @initTime = Time.now
    sortBetween(0, @outputSeq.length - 1)
  end
  
  def sortBetween(index1, index2)
    count = index1
    
    while less(count, index2)
      tmpIndex = indexOfFirstMinBetween(count, index2)
      exchange(count, tmpIndex)
      count += 1
    end
  end
  
  def indexOfFirstMinBetween(firstIndex, lastIndex)
    count = firstIndex + 1
    smallestValue = self.[](firstIndex)
    smallestIndex = firstIndex
    
    while less(count, lastIndex + 1)
      if(less(self.[](count), smallestValue)) 
      then
        smallestValue = self.[](count) 
        smallestIndex = count 
      end
      
      count += 1
    end
    
    return smallestIndex
  end
end