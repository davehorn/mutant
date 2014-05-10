# encoding: utf-8

require 'spec_helper'

describe Mutant::Mutator, 'def' do
  context 'empty' do
    let(:source) { 'def foo; end' }

    let(:mutations) do
      mutations = []
      mutations << 'def foo; raise; end'
    end

    it_should_behave_like 'a mutator'
  end

  context 'empty rescue body' do
    let(:source) { "def foo\nfoo\nrescue\nend" }

    let(:mutations) do
      mutations = []
      mutations << 'def foo; raise; end'
      mutations << 'def foo; nil; rescue; end'
      mutations << 'def foo; end'
    end

    it_should_behave_like 'a mutator'
  end

  context 'with no arguments' do
    let(:source) { 'def foo; true; false; end' }

    let(:mutations) do
      mutations = []

      # Mutation of each statement in block
      mutations << 'def foo; true; true; end'
      mutations << 'def foo; false; false; end'
      mutations << 'def foo; true; nil; end'
      mutations << 'def foo; nil; false; end'

      # Remove statement in block
      mutations << 'def foo; true; end'
      mutations << 'def foo; false; end'

      # Remove all statements
      mutations << 'def foo; end'

      mutations << 'def foo; raise; end'
    end

    it_should_behave_like 'a mutator'
  end

  context 'with arguments' do
    let(:source) { 'def foo(a, b); end' }

    let(:mutations) do
      mutations = []

      # Deletion of each argument
      mutations << 'def foo(a); end'
      mutations << 'def foo(b); end'

      # Deletion of all arguments
      mutations << 'def foo; end'

      # Rename each argument
      mutations << 'def foo(a__mutant__, b); end'
      mutations << 'def foo(a, b__mutant__); end'

      # Mutation of body
      mutations << 'def foo(a, b); raise; end'
    end

    it_should_behave_like 'a mutator'
  end

  context 'with argument beginning in an underscore' do
    let(:source) { 'def foo(_unused); end' }

    let(:mutations) do
      mutations = []
      mutations << 'def foo(_unused); raise; end'
      mutations << 'def foo; end'
    end

    it_should_behave_like 'a mutator'
  end

  context 'with optional argument beginning in an underscore' do
    let(:source) { 'def foo(_unused = true); end' }

    let(:mutations) do
      mutations = []
      mutations << 'def foo(_unused = nil); end'
      mutations << 'def foo(_unused = false); end'
      mutations << 'def foo(_unused = true); raise; end'
      mutations << 'def foo(_unused); end'
      mutations << 'def foo; end'
    end

    it_should_behave_like 'a mutator'
  end

  context 'default argument' do
    let(:source) { 'def foo(a = true); end' }

    let(:mutations) do
      mutations = []
      mutations << 'def foo(a); end'
      mutations << 'def foo(); end'
      mutations << 'def foo(a = false); end'
      mutations << 'def foo(a = nil); end'
      mutations << 'def foo(a__mutant__ = true); end'
      mutations << 'def foo(a = true); raise; end'
    end

    it_should_behave_like 'a mutator'
  end

  context 'define on singleton' do
    let(:source) { 'def self.foo; true; false; end' }

    let(:mutations) do
      mutations = []

      # Body presence mutations
      mutations << 'def self.foo; false; false; end'
      mutations << 'def self.foo; true; true; end'
      mutations << 'def self.foo; true; nil; end'
      mutations << 'def self.foo; nil; false; end'

      # Body presence mutations
      mutations << 'def self.foo; true; end'
      mutations << 'def self.foo; false; end'

      # Remove all statements
      mutations << 'def self.foo; end'

      mutations << 'def self.foo; raise; end'
    end

    it_should_behave_like 'a mutator'
  end

  context 'define on singleton with argument' do

    let(:source) { 'def self.foo(a, b); end' }

    let(:mutations) do
      mutations = []

      # Deletion of each argument
      mutations << 'def self.foo(a); end'
      mutations << 'def self.foo(b); end'

      # Deletion of all arguments
      mutations << 'def self.foo; end'

      # Rename each argument
      mutations << 'def self.foo(a__mutant__, b); end'
      mutations << 'def self.foo(a, b__mutant__); end'

      # Mutation of body
      mutations << 'def self.foo(a, b); raise; end'
    end

    it_should_behave_like 'a mutator'
  end
end
