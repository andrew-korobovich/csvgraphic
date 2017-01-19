public with sharing class CsvReader {
	public static  Blob csvFileBody{get;set;}
	public static String[] csvDataLines {get;set;}
	public static String csvAsString;

	@RemoteAction 
	public static List<Operation> readFile(String filestring){
		Integer startIndex = filestring.indexOf(',')+1;
		String forEncode = filestring.substring(startIndex);
		csvFileBody = EncodingUtil.base64Decode(forEncode);
		csvAsString = csvFileBody.toString();
		List<List<String>> returnedList = readCSVFile();
		List<Operation> operations = generateWrappers(returnedList);
		return operations;
    }

	

    public static List<List<String>> readCSVFile() { 
    	List<List<String>> finalList = new List<List<String>>();
    	csvDataLines = csvAsString.split('\r');
    	for(String record : csvDataLines){
    		List<String> recordValues = record.split('",\"');
    		finalList.add(recordValues);
    	}
    	return finalList;
    }

    public static List<Operation> generateWrappers(List<List<String>> transactionList){
    	List<Operation> operationsList = new List<Operation>();
    	for(List<String> transact : transactionList){
    		if(transact.size() >= 10 && transact[0].length()<4){
    			Operation op = new Operation();
    			op.type = transact[0];
    			op.operationDate = transact[1];
    			op.processingDate = transact[2];
    			op.operationPlace = transact[3];
    			op.operationTitle = transact[4];
    			op.card = transact[5];
    			op.curr = transact[6];
    			op.operationSumm = transact[7];
    			op.summ = transact[8];
    			op.balance = transact[9];
    			operationsList.add(op);
    		}
    	}
    	return operationsList;
    }

    public class Operation{
    	public String type {get; set;}
    	public String operationDate {get;set;}
    	public String processingDate {get;set;}
    	public String operationPlace {get;set;}
    	public String operationTitle {get;set;}
    	public String card{get;set;}
    	public String curr{get;set;}
    	public String operationSumm{get;set;}
    	public String summ{get;set;}
    	public String balance{get;set;}
    }
}