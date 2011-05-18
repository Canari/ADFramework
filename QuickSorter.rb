#Author: Philip Rose & Jan Kuffer
class QuickSorter < AbstractSorter
  
  #Sortierfunktionen
  def sort(seq)
  end
  
  def sort(seq,sortBlock)
  end
  
  def performSort
    @accessCount = 0
    @compareCount = 0
    @initTime = Time.now
    sortBetween(0, @outputSeq.length - 1)
  end
  
  def sortBetween(index1,index2)
    if less(index1, index2) then
      teiler = teile(index1, index2)
      sortBetween(index1, teiler - 1)
      sortBetween(teiler + 1, index2)
    end
  end
  
  def teile(index1,index2)
    i = index1
    j = index2 - 1
    pivot = pivotElement(index1, index2)
    
    begin
      while (compare(self.[](i), pivot) <= 0 and less(i, index2))
        i += 1
      end
      
      while (not(less(self.[](j), pivot)) and less(index1, j))
        j -= 1
      end
      
      if (less(i, j)) then
        exchange(i, j)
      end
    end while less(i, j)
    
    if (less(pivot, self.[](i))) then
      exchange(i, index2)
    end
    
    return i
  end
  
  def pivotElement(index1, index2)
    return self.[](index2)
  end
end