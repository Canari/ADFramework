require "AbstractSorter.rb"
require "SelectionSorter.rb"
require "InsertionSorter.rb"
require "QuickSorter.rb"
require "MergeSorter.rb"

#Author: Philip Rose & Jan Kuffer

algo = [MergeSorter.new, SelectionSorter.new, InsertionSorter.new, QuickSorter.new]
data = [:fillAscending, :fillDescending, :fillAllEqual, :fillRandom]
size = [10, 100, 1000, 10000]

algo.each() { |algoElem|
  data.each() { |dataElem|
    size.each() { |sizeElem|
      algoElem.data(algoElem.send(dataElem, sizeElem))
      algoElem.performSort
      
      puts "\nKlasse: " + algoElem.class.to_s + "\nDaten: " + dataElem.to_s + "\nGröße: " + sizeElem.to_s 
      puts "Ergebnis: " + algoElem.to_s
    }
  }
}