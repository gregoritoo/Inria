import streamlit as st 
import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt 
import os 
import shutil 
import pickle

class Page_two():

    def __init__(self,directory_classes="./classes",directory_imgs="./img"):
        self.directory_classes = directory_classes 
        self.directory_imgs = directory_imgs
        self.already_annotate=""

    def count_classes(self):
        return len(list(os.listdir(self.directory_classes)))

    def main(self):
        nb_classes = int(self.count_classes())
        images = os.listdir(self.directory_imgs)
        selected = False 
        added = False 
        try :
            with open("num.txt", 'r') as f:
                count = int(f.read())
        except Exception as e:
            count = 0
        try :
            image = images[count]
        except Exception as e :
            st.write("No more image to annotate !!")
        st.image(self.directory_imgs+"/"+image)
        st.write("add to : ")
        selected = st.radio("add to class ",np.arange(1,nb_classes+1))
        validate = st.button("validate choice ?")
        added = st.button("create new class")
        try :
            type(nb_classses) == int 
        except Exception :
            print("No class for the moment")

        if selected and validate:
            shutil.copy(self.directory_imgs+"/"+image, "./classes/class_"+str(int(selected))+"/")
            st.write("added in the : "+"./classes/class_"+str(int(selected))+"/"+" folder")
            count = count + 1
            dest = shutil.move(self.directory_imgs+"/"+image, "./classified/"+image) 

        if added  :
            os.mkdir("./classes/class_"+str(nb_classes+1))
            st.write("./classes/class_"+str(nb_classes+1)+ "folder created")
            shutil.copy(self.directory_imgs+"/"+image,"./classes/class_"+str(nb_classes+1)+"/")
            st.write("And image added")
            count = count + 1
            dest = shutil.move(self.directory_imgs+"/"+image, "./classified/"+image) 

        with open('num.txt', 'w') as f:
            f.write('%d' % count)
        f.close()

        st.button("NEXT => ")
        return True

        
        

