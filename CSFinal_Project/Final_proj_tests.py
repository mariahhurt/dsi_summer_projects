#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 27 15:30:39 2019

@author: mariahhurt
"""

#Arti Patel, Elizabeth Driskill, Mariah Hurt, and Sania Rasheed
#Ap8qk, Ekd6bx, Mes3wv, Sr2xn


import unittest

from cs_final import averageSales, averageDecTemp, annualSales

#Test if the Averagesales function is returning the expected values
class AverageSalesTestCase(unittest.TestCase):
    def test_is_average_working(self):
    
        av = averageSales(5)
        
        self.assertEqual(av,318011.8104895105, "The average sales number is not being calculated correctly.")
        
        
        
if __name__ == '__main__':
    unittest.main()          

class AverageDecTempTestCase(unittest.TestCase):
    def test_is_average_dec_temp_working(self):
    
        avgtemp = averageDecTemp(5)
        
        self.assertEqual(avgtemp,50.162, "The average December temperature is not being calculated correctly.")
        
        
        
if __name__ == '__main__':
    unittest.main()          



class AnnualSalesTestCase(unittest.TestCase):
    def test_is_annual_sales_working(self):
    
        ansales = annualSales(5, 2010)
        
        self.assertEqual(ansales,14836030.77, "The annual sales are not being calculated correctly.")
        
        
        
if __name__ == '__main__':
    unittest.main()          


ansales = annualSales(5, 2010)
