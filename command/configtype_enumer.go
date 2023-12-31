// Code generated by "enumer -type configType -trimprefix ConfigType -transform snake"; DO NOT EDIT.

package command

import (
	"fmt"
)

const _configTypeName = "jsonhcl2"

var _configTypeIndex = [...]uint8{0, 4, 8}

func (i configType) String() string {
	if i < 0 || i >= configType(len(_configTypeIndex)-1) {
		return fmt.Sprintf("configType(%d)", i)
	}
	return _configTypeName[_configTypeIndex[i]:_configTypeIndex[i+1]]
}

var _configTypeValues = []configType{0, 1}

var _configTypeNameToValueMap = map[string]configType{
	_configTypeName[0:4]: 0,
	_configTypeName[4:8]: 1,
}

// configTypeString retrieves an enum value from the enum constants string name.
// Throws an error if the param is not part of the enum.
func configTypeString(s string) (configType, error) {
	if val, ok := _configTypeNameToValueMap[s]; ok {
		return val, nil
	}
	return 0, fmt.Errorf("%s does not belong to configType values", s)
}

// configTypeValues returns all values of the enum
func configTypeValues() []configType {
	return _configTypeValues
}

// IsAconfigType returns "true" if the value is listed in the enum definition. "false" otherwise
func (i configType) IsAconfigType() bool {
	for _, v := range _configTypeValues {
		if i == v {
			return true
		}
	}
	return false
}
