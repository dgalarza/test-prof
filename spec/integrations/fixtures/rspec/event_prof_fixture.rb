# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../../../../lib", __FILE__)
require "active_support"
require "test-prof"

TestProf::EventProf.configure do |config|
  config.per_example = true
end

module Instrumenter
  def self.notify(event = "test.event", time)
    ActiveSupport::Notifications.publish(
      event,
      0,
      time
    )
  end
end

describe "Something" do
  it "invokes once" do
    Instrumenter.notify 'test.event', 40.1
    expect(true).to eq true
  end

  it "invokes twice" do
    Instrumenter.notify 'test.event', 140
    Instrumenter.notify 'test.event', 240
    Instrumenter.notify 'test.another_event', 110
    expect(true).to eq true
  end

  it "invokes many times" do
    Instrumenter.notify 'test.event', 14
    Instrumenter.notify 'test.event', 40
    Instrumenter.notify 'test.event', 42
    Instrumenter.notify 'test.event', 40
    Instrumenter.notify 'test.another_event', 11
    expect(true).to eq true
  end
end

describe "Another something" do
  it "do nothing" do
    expect(true).to eq true
  end

  it "do very long" do
    Instrumenter.notify 'test.event', 1000
    Instrumenter.notify 'test.another_event', 1321
    expect(true).to eq true
  end
end
