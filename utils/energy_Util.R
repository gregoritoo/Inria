
path="/home/salah/energy/ciment-dahu/colmet/colmet/"



read_original_swf <-function(path, header_size=0,partition =-1){
  d=read.csv(path,header = FALSE,skip = header_size,sep="")
  #print(d)
  names(d)=c("Job_Number","Submit Time","Wait Time","Run Time","Number of Allocated Processors","Average CPU Time Used","Used Memory","Requested Number of  Processors","Requested Time","Requested Memory","Status","User_ID","Group_ID","Executable (Application) Number","Queue Number","Partition Number","Preceding Job Number","Think Time from Preceding Job")
  d=d%>%filter(`Number of Allocated Processors`>0  &`Requested Time`>0)
  if (partition!=-1){
    d= d %>%filter(`Partition Number`==partition )
    d= d %>%filter( Status!=1 )
  }
  
  
  return(d)
  
}


read_original_owf <-function(path="",header_size=" "){
  d=read.csv(path,header = FALSE,skip = header_size,sep=" ")
  names(d)=c("job_id","submission_time_oar","start_time_oar","stop_time_oar","walltime_oar","nb_default_resources_oar","nb_extra_ressources_oar","status_oar","user_oar","command_oar","queue_oar","name_oar","array_oar","type_oar","reservation_oar","cigri_oar")
  
  
  return(d)
  
}

create_single_job <-function(job){
  single_job=data.frame(
    #procs=paste( unlist(unique(job$hostname)), collapse=','),
    start_colmet=min(job$timestamp),
    end_colmet=max(job$timestamp))
  single_job$runtime_colmet=single_job$end_colmet-single_job$start_colmet
  return(single_job)
}

job_load_taskstats_default <- function(file, job_id) {
  jobdata <- h5read(file,
                    paste0("/job_", job_id, "/taskstats_default"), 
                    bit64conversion="double");
  return(jobdata)
}

job_load_perf_events <- function(file, job_id) {
  jobdata <- h5read(file,
                    paste0("/job_", job_id, "/perfhwstats_default"), 
                    bit64conversion="double");
  
  #print(distinct(jobdata, hostname))
  nanotosec <- 0.000000001 #10e-9
  microtosec <- 0.000001 #10e-6
  
  
  return(jobdata)
}


job_load_rapl_events <- function(file, job_id) {
  jobdata <- h5read(file,
                    paste0("/job_", job_id, "/RAPLstats_default"), 
                    bit64conversion="double");
  
  #print(distinct(jobdata, hostname))
  #print(jobdata)
  return (jobdata)
  
  
}

read_file_list <- function (path){
  files=list.files(path)
  return(files)
}
generate_temporal_features <- function(d){
  
  time_zero=893466664
  d$true_S_time=d$timestamp+time_zero
  d$exact_date=as.POSIXct(d$true_S_time,origin = "1970-01-01  00:00:00",tz = "GMT")
  d$date=as.Date(as.POSIXct(d$true_S_time,origin = "1970-01-01  00:00:00",tz = "GMT"))
  d$time=as.ITime(as.POSIXct(d$true_S_time,origin = "1970-01-01  00:00:00",tz = "GMT"))
  
  d$week=week(d$date)
  d$time=(as.numeric(d$time))
  d$day_of_week=weekdays(d$date)
  d$month=months(d$date)
  
  d$quarters=quarters(d$date)
  d$year=year(d$date)
  d$day_of_month=(as.POSIXlt(d$date)$mday)
  ## converting days of the chars to numbers
  strings=sort(unique(d$day_of_week))
  day_num=1:length(strings)
  names(day_num)=strings
  d$day_of_week=day_num[d$day_of_week]
  
  
  strings=sort(unique(d$quarters))
  quarters_num=1:length(strings)
  names(quarters_num)=strings
  d$quarters=quarters_num[d$quarters]
  
  
  
  strings=sort(unique(d$month))
  month_num=1:length(strings)
  names(month_num)=strings
  d$month=month_num[d$month]
  #d$true_S_time=NULL
  
  
  return (d)
}


draw_gantt_oar_2 <- function(workload="",title ="??") {
  
  
  # we read the workload 
  #print(workload)
  
  
  # Start ploting
  a= workload  %>%
    ggplot(aes( xmin=start_time_oar,
                ymin=psetmin,
                ymax=psetmax + 0.9,
                xmax=stop_time_oar,
                # here it will set the alpha globaly
                #alpha=job_id,
                fill=as.character(cigri_oar)))  + #scale_fill_viridis(discrete=T) +
    # This draw the rectangles
    geom_rect(color="black", size=0.1) +
    # And we add the labels of the job id
    geom_text(aes(x=start_time_oar +(stop_time_oar-start_time_oar)/2, # size=stretch,
                  y=psetmin+((psetmax-psetmin)/2)+0.5,
                  label=paste(job_id, "")), alpha=1,check_overlap = TRUE) +
    
    xlim(sample_start-20000,sample_end+20000)+
    ylab("resources") + xlab("time (in seconds)")+ggtitle(title)
  return(a)
}
draw_gantt_oar_single_job <- function(workload="",title ="??") {
  
  
  # we read the workload 
  #print(workload)
  
  
  # Start ploting
  a= workload  %>%
    ggplot(aes( xmin=start_time_oar,
                ymin=psetmin,
                ymax=psetmax + 0.9,
                xmax=stop_time_oar,
                # here it will set the alpha globaly
                #alpha=job_id,
                fill=as.character(cigri_oar)))  + #scale_fill_viridis(discrete=T) +
    # This draw the rectangles
    geom_rect(color="black", size=0.1) +
    # And we add the labels of the job id
    geom_text(aes(x=start_time_oar +(stop_time_oar-start_time_oar)/2, # size=stretch,
                  y=psetmin+((psetmax-psetmin)/2)+0.5,
                  label=paste(job_id, "")), alpha=1,check_overlap = TRUE) +

    ylab("resources") + xlab("time (in seconds)")+ggtitle(title)
  return(a)
}

draw_gantt_oar_proc <- function(workload="",title ="??") {
  
  
  # we read the workload 
  #print(workload)
  
  
  # Start ploting
  a= workload  %>%
    ggplot(aes( xmin=start_time_oar,
                ymin=psetmin,
                ymax=psetmax + 0.9,
                xmax=stop_time_oar,
                # here it will set the alpha globaly
                #alpha=job_id,
                fill=as.character(cigri_oar)))  + #scale_fill_viridis(discrete=T) +
    # This draw the rectangles
    geom_rect(color="black", size=0.1) +
    # And we add the labels of the job id
    geom_text(aes(x=start_time_oar +(stop_time_oar-start_time_oar)/2, # size=stretch,
                  y=psetmin+((psetmax-psetmin)/2)+0.5,
                  label=paste(job_id, "")), alpha=1,check_overlap = TRUE) +
    
    #xlim(sample_start-20000,sample_end+20000)+
    facet_wrap(~processor)+
    ylab("resources") + xlab("time (in seconds)") #+ggtitle(title)
  return(a)
}

