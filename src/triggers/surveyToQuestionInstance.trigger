trigger surveyToQuestionInstance on survey__c (after insert) 
{
    List<Question__c> Qlist = new List<Question__c>();
    
    //Atul: Aug 15 2018 03:00 am
    //List<List<QuestionInstance__c>> llqi = new List<List<QuestionInstance__c>>();
    // instead create a normal list and use addAll method in the loop
    List<QuestionInstance__c> allQIs = new List<QuestionInstance__c>();
    
    QList = [Select id, Name, QuestionText__c, section__c from Question__c];
    
        for(survey__c sur : trigger.new)
        {
            List<QuestionInstance__c> QIlist = new List<QuestionInstance__c>();
            for(Question__c qnow : QList )
            {
                //Atul: Aug 15 2018 03:00 am
                QuestionInstance__c qi = new QuestionInstance__c();
                qi.QuestionText__c = qnow.QuestionText__c;
                qi.section__c = qnow.section__c;
                qi.survey__c = sur.id;
                qi.questionId__c = qnow.id;
                QIList.add(qi);
                
                //QuestionInstance__c.QuestionInstanceText__c = quelist.Question__c.QuestionText__c;
            } // end of question for loop
            
            //Atul: Aug 15 2018 03:00 am
            allQIs.addAll(QIlist); // build the grand list of QIs
        } // end of survey for loop
        
        insert(allQIs);
}