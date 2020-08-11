package main

import (
	"testing"
)

func TestHandleRequest(t *testing.T) {
	HandleRequest(nil, MyEvent{Name: "test"})
}
