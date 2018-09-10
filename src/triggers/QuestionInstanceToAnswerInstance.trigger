trigger QuestionInstanceToAnswerInstance on QuestionInstance__c (after insert) {

    Map<id,List<Answer__c>> qasMap = new Map<id,List<Answer__c>>();
    
    List <Question__c> QList = [Select id, Name, QuestionText__c, section__c from Question__c];
    List <Answer__c> AList = [select id,name,answer__c, points__c, question__c from Answer__c];
    
    List <AnswerInstance__c> allAiList = new List<AnswerInstance__c>();
    // prepare per questions list of answers for that question
    // then add to map
    for (Question__c qNow : QList){
        List <Answer__c> qasList = new List<Answer__c>(); //new AnswerList for each Question
        for (Answer__c aNow : AList) {
            if (qNow.id == aNow.question__c)
                // this answer is for the this question so add to the list
                qasList.add(aNow);
        }
        //add entry into map for this question and the anslist
        qasMap.put(qNow.id, qasList);
    }
    for (QuestionInstance__c qiNow : Trigger.new) {
        // step1:get the QuestionId from QuestionInstance
        id qid = Id.valueOf(qiNow.questionId__c);
        // step2:Using the map, get answersList for QuestionId
        List <Answer__c> myAnswers = qasMap.get(qid);
        // step3:Iterate over AnswersList create (replicate) AnswerInstances
        List <AnswerInstance__c> aiList = new List<AnswerInstance__c>();
        for (Answer__c myAns : myAnswers) {
            AnswerInstance__c ai = new AnswerInstance__c();
            ai.name = myAns.name ;
            ai.answer__c = myAns.Answer__c;
            ai.points__c = myAns.points__c ;
            ai.questionInstance__c =  qiNow.id;
            
            aiList.add(ai);
        } // end for loop of myAnswers
        
        //Step4: keep building the grand ailist to be inserted at last
        allAiList.addAll(aiList);
        
    } // end for loop of trigger.new
    
    insert allAiList;
}