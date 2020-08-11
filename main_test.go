package main

import (
	"context"
	"fmt"
	"testing"
)

func TestHandleRequest(t *testing.T) {
	_, err := HandleRequest(context.TODO(), MyEvent{Name: "test"})
	if err != nil {
		fmt.Println("Whoops")
	}
}
