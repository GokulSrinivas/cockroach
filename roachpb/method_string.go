// generated by stringer -type=Method; DO NOT EDIT

package roachpb

import "fmt"

const _Method_name = "GetPutConditionalPutIncrementDeleteDeleteRangeScanReverseScanEndTransactionAdminSplitAdminMergeHeartbeatTxnGCPushTxnRangeLookupResolveIntentResolveIntentRangeNoopMergeTruncateLogLeaderLeaseBatch"

var _Method_index = [...]uint8{0, 3, 6, 20, 29, 35, 46, 50, 61, 75, 85, 95, 107, 109, 116, 127, 140, 158, 162, 167, 178, 189, 194}

func (i Method) String() string {
	if i < 0 || i >= Method(len(_Method_index)-1) {
		return fmt.Sprintf("Method(%d)", i)
	}
	return _Method_name[_Method_index[i]:_Method_index[i+1]]
}
