import streamlit as st 
import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt 
import os 


class Page_one():

    def __init__(self,directory="./classes") : 
        self.directory = directory  


    def count_classes(self):
        return len(list(classes = os.listdir(self.directory)))

    def show_classes(self):
        classes = os.listdir(self.directory)
        if len(list(classes)) < 1 :
            st.write("No classe for the moment")
        else :
            for class_element in classes :
                num_class = [int(s) for s in str(class_element) if s.isdigit()][0]
                print(num_class)
                figures = os.listdir(self.directory+"/"+class_element+"/")
                figure = figures[0]
                st.write(class_element.replace("_"," n° "))
                st.image(self.directory+"/"+class_element+"/"+figure)
 
 