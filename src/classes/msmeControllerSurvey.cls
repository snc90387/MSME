public with sharing class msmeControllerSurvey {

   public String currentSection { get; set; }
   private integer counter=0;  //keeps track of the offset
   private integer list_size=1; //sets the page size or number of rows
   public integer total_size; //used to show user the total size of the list
   Question__c[] questions ;
   QuestionInstance__c[] qis ;
   Answer__c[] answers;
   AnswerInstance__c[] ais;

  private Contact currentcontact = Null;

    Map <id, List<AnswerInstance__c>> qiaisMap = new Map<id, List<AnswerInstance__c>>();
   
   //constructor
   public msmeControllerSurvey () {
         total_size = [select count() from Question__c]; //set the total size in the constructor
         //total_size = total_size + 1; // needed for limit = 1
         currentSection = 'demographic'; // default
    }
    
     public String getName() {
         getContact();
        return currentcontact.name;
    }

    public Contact getContact() {
    if(currentcontact == Null){
        
         Id cId = ApexPages.currentPage().getParameters().get('id');
         currentcontact = [select Id, Name from Contact where Id = '0036F00002bIOr7']; //:cId];
         }
         return currentcontact;
    }

         // IMPORTANT NOTE:
         // Following code is moved to getQuestions()
         // if done in constructor then this is only one time at the creation
         // but we want to get the list a new everytime next or previous buttons are clicked. If code is in 
         //    constructor then the same first question is shown as the query is not re executed with new counter value.
         /*** 
         try {
         qis = [select section__c, questionid__c, questionText__c 
                                from QuestionInstance__c 
                                order by section__c
                                limit :list_size 
                                offset :counter];

         
      } catch (QueryException e) {
         ApexPages.addMessages(e);   

      }
      
      // get answers 
      try {
               answers = [select answer__c, points__c, question__c
                                from Answer__c 
                         ];

      
      } catch (QueryException ee) {
          ApexPages.addMessages(ee);  
      }
      ***/
  

    
   public PageReference Beginning() { //user clicked beginning
      counter = 0;
      

      return null;
   }

   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      return null;
   }

   public PageReference Next() { //user clicked next button
      counter += list_size;
      return null;
   }

   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      return null;
   }

   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }

   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }

   public Integer getTotal_size() {
      return total_size;
   }

   public Integer getPageNumber() {
      return (counter/list_size + 1) ; // was +1
   }

   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }
   /*public String getCurrentSection() {
       return m_currentSection;
   }*/

   
   
   public QuestionInstance__c[] getQuestions() {
         try {
         qis = [select id,name,section__c, questionid__c, questionText__c 
                                from QuestionInstance__c 
                                order by section__c
                                limit :list_size 
                                offset :counter];
                                
         Id qid = qis[0].id ;
         system.debug('*** ID = ' + qid);
         String qidName = qis[0].name;
                                
         ais = [select id,name,questionInstance__c
                                from AnswerInstance__c 
                                where QuestionInstance__c= :qid
                                ];

         
      } catch (QueryException e) {
         ApexPages.addMessages(e);   

      }
      return this.qis;
   }
   
   public AnswerInstance__c[] getAnswers() {
       return this.ais;
   }

}