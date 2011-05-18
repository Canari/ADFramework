#Author: Philip Rose & Jan Kuffer
class InsertionSorter < AbstractSorter
  
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
    tmpVar = nil
    
    (index1 + 1).upto(index2) do |i|
      tmpVar = self.[](i)
      j = i
      
      while (j > 0 and less(tmpVar, self.[](j - 1))) do
        self.[]=(j, self.[](j - 1))
        j -= 1
      end
      
      self.[]=(j, tmpVar)
    end
  end 
end