require "Extensions_OO_V1.rb"


#Author: Philip Rose & Jan Kuffer
class AbstractSorter
  
  DEF_BLOCK = Proc.new {|a,b| a <=> b}
  
  def initialize
    #Variablendeklaration:
     @checkOn = true
     @inputSeq = []
     @outputSeq = []
     @sortBlock = DEF_BLOCK
     
     @accessCount = 0
     @compareCount = 0
     @initTime = 0
  end
  
  def getCollection
    return @outputSeq
  end
  
  #Setter Methoden
  def data(col)
    @inputSeq = col.clone
    @outputSeq = col.clone
  end
  
  def sortBlock(twoArgBlock)
    if(@checkOn) then check_pre(twoArgBlock.is_a?(proc),"twoArgBlock ist keine prozedur") end
      
    @sortBlock = twoArgBlock
    
    if(@checkOn) then check_post(@sortBlock.is_a?(proc),"sortBlock ist keine prozedur") end
  end
  
  def checkOn
    @checkOn = true
  end
  
  def checkOff
    @checkOn = false
  end
  
  #Zugriffe und Vergleiche
  def [](index)
    if(@checkOn) then check_pre(index.int?(),"index kein integer") end
      
    accessCountInc
    return @outputSeq[index]
  end
  
  def []=(index,object)
    if(@checkOn) then check_pre(index.int?(),"index kein integer") end
    
    accessCountInc  
    @outputSeq[index] = object
  end
  
  def exchange(index1, index2)
    if(@checkOn) then check_pre((index1.int?() and index2.int?()),"index kein integer") end
    
    tmp = self.[](index1)
    self.[]=(index1, self.[](index2))
    self.[]=(index2, tmp)
  end
  
  def compare(obj1,obj2)    
    compareCountInc
    return @sortBlock.call(obj1,obj2)
  end
  
  def less(obj1, obj2)    
    return (compare(obj1, obj2) < 0)
  end
  
  def compareExchange(index1,index2)
    if(compare(index1, index2) < 0) then exchange(index1, index2) end
  end
  
  #Invarianten und Postconditions
  def isSortedBetween(firstIndex,lastIndex)
    if(@checkOn) then check_pre((firstIndex.int?() and lastIndex.int?() and firstIndex < lastIndex),"indizes keine integer") end
    
    tmpCol = []
    firstIndex.upto(lastIndex) do |i|
      tmpCol.push(@outputSeq[i])
    end
    
    return sorted?(tmpCol)
  end
  
  def isSorted
    return sorted?(@outputSeq)
  end
  
  def isPermutation
    if (@inputSeq.length() != @outputSeq.length()) then return false end
    
    flagCol = Array.new(@outputSeq.length(), 1)
    
    @inputSeq.each_with_index {|elem1, index1|
      @outputSeq.each_with_index {|elem2, index2|
        if (flagCol[index2] == 1 and elem1.equal?(elem2)) then flagCol[index2] = 0; break; end
      }
    }
    
    return (not flagCol.include?(1))
  end
  
  def isStableSorted
    @outputSeq.each_cons(2){|elem1, elem2|
      if(compare(elem1, elem2) == 0)
        return false unless (@inputSeq.index(elem1) < @inputSeq.index(elem2))
      end
    }
    
    return true
  end
  
  #Füllen mit Zahlen
  def fillAscending(count)
    if(@checkOn) then check_pre(count.int?(),"count kein integer") end
      
    tmpVar = []
    1.upto(count) do |x|
      tmpVar.push(x)
    end
    
    (0..(count-1)).to_a
    
    @outputSeq = tmpVar
  end
  
  def fillDescending(count)
    if(@checkOn) then check_pre(count.int?(),"count kein integer") end
      
    tmpVar = []
    count.downto(1) do |x|
      tmpVar.push(x)
    end
    
    @outputSeq = tmpVar      
  end
  
  def fillAllEqual(count)
    if(@checkOn) then check_pre(count.int?(),"count kein integer") end
      
    tmpVar = []
    1.upto(count) do
      tmpVar.push(count)
    end
    
    @outputSeq = tmpVar
  end
  
  def fillRandom(count)
    if(@checkOn) then check_pre(count.int?(),"count kein integer") end
      
    tmpVar = []
    1.upto(count) do
      tmpVar.push(rand(count))
    end
    
    @outputSeq = tmpVar
  end
  
  def fillWithString(fileName) 
    if(@checkOn) then check_pre(fileName.string?(), "Ungültiger Dateipfad") end
       
    tmpVar=[]
    File.open(fileName) { |file|
      file.each_line { |line|
        tmpVar.push(line)
      }
    }
    
    @outputSeq = tmpVar
  end
  
  def accessCountInc
    @accessCount += 1
  end
  
  def compareCountInc
    @compareCount += 1
  end
  
  def sorted?(col)
    col.each_cons(2) do |pre,elem|
      if (compare(pre, elem) == 1) then return false end
    end
    
    return true
  end
  
  def sort
  end  
  
  def to_s
    "TimeElapsed: " + (Time.now - @initTime).to_s +
    "  //  AccessCounter: " + @accessCount.to_s +
    "  //  CompareCounter: " + @compareCount.to_s
  end
end