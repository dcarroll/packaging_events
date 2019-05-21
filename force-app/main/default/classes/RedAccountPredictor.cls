public class RedAccountPredictor {

    private static final Integer MAX_CASES_EXPECTED = 2;
    
    public RedAccountPredictor() { }
    
    // Perform slow, resource intensive calcuation to determine if Account is in RED status (think Einsein predictions, etc.)
    public Map<String, boolean> predict(List<String> acctIds) {
        List<Case> casesForAccounts = [SELECT Id, Account.Id, Status, CaseNumber, Priority, IsEscalated FROM Case WHERE AccountId IN :acctIds AND Status !='Closed'];
		Map<String, List<Case>> accountsToCases = new Map<String, List<Case>>();
        for (Case c : casesForAccounts) {
            if (null == c.Account.Id) continue;
            if (!accountsToCases.containsKey(c.Account.Id)) {
                accountsToCases.put(c.Account.Id, new List<Case>());
            }
            accountsToCases.get(c.Account.Id).add(c);
        }
        Map<String, boolean> results = new Map<String, boolean>();
        for (String acctId : accountsToCases.keySet()) {
            results.put(acctId, predict(accountsToCases.get(acctId)));
        }
        return results;
    }
    
    private boolean predict(List<Case> casesForAccount) {
        boolean isEscalated = false;
        boolean hasSlaViolation = false;
        boolean hasHighPiority = false;
        boolean allStatusesResolved = true;
        for (Case openCase : casesForAccount) {
            isEscalated |= openCase.IsEscalated;
            hasHighPiority |= openCase.Priority == 'High';
            allStatusesResolved &= (openCase.Status == 'Closed' || openCase.Status == 'Part Received');
        }
        if (allStatusesResolved) {
            return false;
        }
        if (casesForAccount.size() > MAX_CASES_EXPECTED) {
            return true;
        } else if (isEscalated || hasSlaViolation) {
            return true;
        } else if (hasHighPiority) {
            return true;
        }
        return false;
    }
    
    public Map<String, boolean> predictForCases(List<String> caseId) {
        List<Case> casesMatchingIds = [SELECT Id, Account.Id FROM Case WHERE Id IN :caseId];
        if (null != casesMatchingIds && casesMatchingIds.size() > 0) {
            List<String> accountIds = new List<String>();
            for (Case c : casesMatchingIds) {
                accountIds.add(c.Account.Id);
            }
            return predict(accountIds);
        } else {
            return new Map<String, boolean>();
        }
    }
    
}